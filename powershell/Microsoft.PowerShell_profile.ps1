# Testing the writing of aliases
#
# NOTE: Remap most of the useful commands that are present in the UNIX command

Function vim { & "C:\Users\luis\vim_installation\Vim\vim91\vim.exe" @Args }

Function lsa { Get-ChildItem -Force }

Function rmr { Remove-Item -Recurse -Force }

Function codigos { Set-Location "C:\Users\luis\Desktop\infos\codigos" }

Function github { Set-Location "C:\Users\luis\Desktop\infos\codigos\__github_remote_repositories\" }

