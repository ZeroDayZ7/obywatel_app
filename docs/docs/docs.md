adb devices

5200d78bfa479449 device
310008a89dd353f9 unauthorized

scrcpy -s 5200d78bfa479449

flutter run
adb -s 5200d78bfa479449 reverse tcp:8081 tcp:8081
.\scrcpy -s 5200d78bfa479449 --max-size 600 --video-bit-rate 8M --video-buffer 2 --max-fps 60