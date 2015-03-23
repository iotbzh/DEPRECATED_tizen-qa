user --name admin  --groups audio,video,weston-launch --password 'tizen'

user --name alice  --groups audio,video,weston-launch --password 'tizen'
user --name bob  --groups audio,video,weston-launch --password 'tizen'
user --name carol  --groups audio,video,weston-launch --password 'tizen'

desktop --autologinuser=admin  

%packages

%end


