# Drawpile

This is a dockerfile for the Drawpile dedicated server
build with `docker build -t drawpile-server --build-arg DOWNLOAD_SRV=Drawpile-srv-x.y.z.AppImage .`
where x.y.z correspond to a version available at https://drawpile.net/files/appimage/

Run it with `docker run -p 27750:27750 norweeg/drawpile-server`.

You can use a different port with `docker run -p 1234:27750 norweeg/drawpile-server`.

Try `docker run norweeg/drawpile-server -h` for help with drawpile server's argument list.
