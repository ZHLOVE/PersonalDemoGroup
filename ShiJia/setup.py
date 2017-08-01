import os
#os.system('/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')
os.system('brew install boost')
os.system('npm install')
os.system('rm -rf ./Pods')
os.system('rm ./Podfile.lock')
os.system('pod install')
