# Docker Hexo
Docker Image for [Hexo](https://hexo.io/)

## Run:

Add the following to create (and persist) alias to `~/.bash_profile` (or `~/.zshrc` if using zsh):

```bash
alias hexo="docker run -it --rm \
  -v `pwd`:/opt/node_app/app \
  -p 4000:4000 \
  martindsouza/hexo:latest"
```

You can then run all hexo commands as you normally would with the caveat that the container ***can only see the current directory or any of its children***. i.e. don't run commands like `hexo init ../../my-new-blog`


### MacOS Users

Since Docker for Mac uses a VM behind the scenes, referencing the current directory's `node_modules` folder may be very slow. If that's the case, delete the hosts (i.e. your laptop's) `node_modules` folder and the container has its own copy which will be faster.


## Update

To update the image run: `docker pull martindsouza/hexo`

## Developing

If working on this image all the build scripts are registered as [Tasks](https://code.visualstudio.com/docs/editor/tasks) in [VSCode](https://code.visualstudio.com/)

