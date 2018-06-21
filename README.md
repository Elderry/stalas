# Configuration Manager
This project is maintained to keep configurations easily being tracked across Windows and macOS. Including PowerShell, Hyper and Visual Studio Code etc. All scripts are tested on Windows 10 and macOS High Sierra.
## Prerequisites
This project requires PowerShell Core installed.
## Use
In PowerShell Core, excute commands below:
```powershell
./config.ps1 <target> # In project's directory.
```
To avoid jumping to project's directory all the time, it is recommanded to set alias like:
- Windows
```powershell
Set-Alias config '<Project Root>/config.ps1'
```
- macOS
```powershell
$config = '<Project Root>/config.sh'
```
Then the belowing command can be called anywhere:
- Windows
```powershell
config <target> # After alias is set.
```
- macOS
```powershell
& $config <target>
sudo $config <target> # Using root privilege.
```
## Customize
This project is easy to customize, you can create your configuraitons in `Configuration` directory, make sure there is a `Configuration.ps1` file in it.
## Contact
Any problem, feel free to contact `Elderry@outlook.com`.
