adb devices

5200d78bfa479449 device
310008a89dd353f9 unauthorized

adb -s 5200d78bfa479449 reverse tcp:8081 tcp:8081

.\scrcpy -s 5200d78bfa479449
.\scrcpy -s 310008a89dd353f9

flutter run
.\scrcpy -s 5200d78bfa479449 --video-buffer 2 --max-fps 60

!D/ViewR, !D/InputM, !D/InputT, !V/InputMetho, !I/InputMetho, !I/AssistStr, !D/Surf, !W/libE, !D/vndksup, !E/ViewR, !W/ViewR

adb -s 5200d78bfa479449 shell top



