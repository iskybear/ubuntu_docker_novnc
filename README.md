# ubuntu_novnc
A dockerfile with novnc web-interface

inside the folder:

```console
docker build -t ubuntu_novnc .
docker run --rm -it -p 6080:6080 ubuntu_novnc
```

And then http://localhost:6080/vnc.html in a browser