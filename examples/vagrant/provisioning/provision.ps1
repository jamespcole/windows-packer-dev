$serverAddress = 'localhost'
$instanceName = 'SQLEXPRESS'

write-output "Installing IIS features..."
#Add additional IIS modues here
$features = @(   
   "IIS-NetFxExtensibility45",
   "IIS-ASPNET45"
)
Enable-WindowsOptionalFeature -Online -FeatureName $features 


write-output "Configuring IIS Site..."
Import-Module "WebAdministration"
Remove-Item 'iis:\Sites\Default Web Site' -force -recurse -Confirm:$false
New-Item 'iis:\Sites\Default Web Site' -bindings @{protocol="http";bindingInformation=":80:"} -physicalPath c:\vagrant


#import SQL Server module
Import-Module SQLPS -DisableNameChecking

# Connect to the instance using SMO
$s = new-object ('Microsoft.SqlServer.Management.Smo.Server') "$serverAddress\$instanceName"
[string]$nm = $s.Name
[string]$mode = $s.Settings.LoginMode

write-output "Instance Name: $nm"
write-output "Login Mode: $mode"

#Change to Mixed Mode
$s.Settings.LoginMode = [Microsoft.SqlServer.Management.SMO.ServerLoginMode]::Mixed

# Make the changes
$s.Alter()


$databases = @(
   @{
      'Name' = 'new_database';
      'Users' = @(
         @{
            'LoginName' = 'user_login_name';
            'Username' = 'user_name';
            'Password' = 'user_password';
            'Role' = 'db_owner';
         }
      );
      'FixturesFiles' = @(
         'C:\vagrant\your_project\database\fixtures.sql'
      );
   }
)

function CreateDatabasesAndUsers($databases, $serverAddress, $instanceName) {

   $server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList "$serverAddress\$instanceName"

   foreach($database in $databases)  
   {
      $dbname = $database.Name
      if ( $null -ne $server.Databases[$database.Name] ) 
      {
         write-output "Dropping database $dbname"
         #drop the database         
         $server.KillAllProcesses($dbname)
         $server.KillDatabase($dbname)         
      }

      write-output "Creating database $dbname"
      #create the database     
      $db = New-Object Microsoft.SqlServer.Management.Smo.Database($server, $database.Name)
      $db.Create()
      Write-Host $db.CreateDate   

      foreach($user in $database.Users)
      {
         $username = $user.Username         
         $loginname = $user.LoginName
         $password = $user.Password
         write-output "Creating user $username on $dbname"

         $dbobj = $server.Databases[$dbname]

         # drop login if it exists
         if ($server.Logins.Contains($loginname))  
         {   
             Write-Host("Deleting the existing login $loginname.")
                $server.Logins[$loginname].Drop() 
         }

         $login = New-Object `
         -TypeName Microsoft.SqlServer.Management.Smo.Login `
         -ArgumentList $server, $loginname
         $login.LoginType = [Microsoft.SqlServer.Management.Smo.LoginType]::SqlLogin
         $login.PasswordExpirationEnabled = $false
         $login.PasswordPolicyEnforced = $false
         $login.Create($password)
         Write-Host("Login $loginname created successfully.")

         if ($dbobj.Users[$username])
         {
            Write-Host("Dropping user $username on $dbname.")
            $dbobj.Users[$username].Drop()
         }

         $dbUser = New-Object `
         -TypeName Microsoft.SqlServer.Management.Smo.User `
         -ArgumentList $dbobj, $username
         $dbUser.Login = $loginname
         $dbUser.Create()
         Write-Host("User $username created successfully.")

         #assign database role for a new user
         $dbrole = $dbobj.Roles[$user.Role]
         $dbrole.AddMember($username)
         $dbrole.Alter()
         $roleName = $user.Role
         Write-Host("User $dbUser successfully added to $roleName role.")
      }
      
   }

   write-output "Restarting SQL Server"
   Get-Service -computer $serverAddress 'MSSQL$SQLEXPRESS' | Restart-Service
}


#remove this line if you don not want to create databases
CreateDatabasesAndUsers $databases $serverAddress $instanceName


#if you need to run database migrations then define them here
#unfortunately Entity Framework and others need to be built before the migrations can be run so we just just build to a temp directry then execute
#NOTE: for EF migration to work the configured connection string in your web.config or app.config should match one of the databases configured above
$migrations = @(
   @{      
      Type = "EF";
      BuildCommand = 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe "C:\vagrant\your_project\Your.Project\Your.Project.DAL\Your.Project.DAL.csproj" /p:VisualStudioVersion=12.0 /p:OutDir=$env:temp\build /p:Configuration=Release /t:Build';
      MigrationExecutable = 'C:\vagrant\your_project\Your.Project\packages\EntityFramework.6.1.0\tools\migrate.exe';
      OutputDir = "$env:temp\build";
      MigrationsFile = 'Your.Project.DAL.dll';
      ConfigFile = 'C:\vagrant\your_project\Your.Project\Your.Project.API\web.config';
   }
)

foreach($migration in $migrations) 
{
   write-output "Running migration..."
   $outputDir = $migration.OutputDir
   write-output $migration.BuildCommand
   iex "& $($migration.BuildCommand)"
   Copy-Item $migration.MigrationExecutable "$($migration.OutputDir)"
   $migrateCommand = "`"$($migration.OutputDir)\migrate.exe`" `"$($migration.MigrationsFile)`" /startupConfigurationFile=`"$($migration.ConfigFile)`""   
   write-output $migrateCommand
   iex "& $($migrateCommand)"
   Remove-Item "$($migration.OutputDir)" -force -recurse -Confirm:$false
}  


import-module sqlps;

foreach($database in $databases) 
{
   if ( $null -ne $database.FixturesFiles ) {
      write-output "Processing fixtures for $($database.Name)..."
      foreach($fixtureFile in $database.FixturesFiles) 
      {
        write-output "Processing fixture file $fixtureFile"
        
        $myData = invoke-sqlcmd -InputFile "$fixtureFile" -serverinstance "$serverAddress\$instanceName" -database $database.Name;
        #$mydata | out-file c:\users\outputuser.sql;
        write-output $myData
        
      }
   } 
}

$vpn = get-vpnconnection -name "Test VPN" -erroraction SilentlyContinue
if (!$vpn) {
   
}
else {
   Remove-VpnConnection -Name "Test VPN" -Force
}

add-vpnconnection -name "Test VPN" -serveraddress "vpn.example.com"  -splittunneling -usewinlogoncredential -tunneltype "Automatic"
