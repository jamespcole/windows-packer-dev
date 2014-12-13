
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

choco install sublimetext3.app

choco install google-chrome-x64

#choco install git.install
choco install git.install -overrideArgs -installArgs '"/VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /NOICONS  /COMPONENTS="''icons,icons\quicklaunch,icons\desktop,ext,ext\reg,ext\reg\shellhere,assoc,assoc_sh''" /LOG"'

write-output "Enabling IIS Features..."
$features = @(   
   "IIS-WebServerRole",
   "IIS-WebServer",
   "IIS-StaticContent",
   "IIS-DefaultDocument",
   "IIS-DirectoryBrowsing",
   "IIS-HttpErrors",
   "IIS-HttpRedirect",
   "IIS-ApplicationDevelopment",
   "IIS-ApplicationDevelopment",
   "IIS-WebServerManagementTools",
   "IIS-ISAPIExtensions",
   "IIS-ISAPIFilter"
)
Enable-WindowsOptionalFeature -Online -FeatureName $features 

choco install MsSqlServer2012Express

choco install visualstudiocommunity2013