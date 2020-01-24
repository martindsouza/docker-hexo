# Docker hexo-cli
Docker Image for [Hexo](https://hexo.io/) `hexo-cli`.

## Run:

Add the following to create (and persist) alias to `~/.bash_profile` (or `~/.zshrc` if using zsh):

```bash
alias hexo="docker run -it --rm \
  -v `pwd`:/opt/node_app/app \
  -p 4000:4000 \
  -p 3000:3000 \
  martindsouza/hexo:latest"
```

You can then run all hexo commands as you normally would with the caveat that the container ***can only see the current directory or any of its children***. i.e. don't run commands like `hexo init ../../my-new-blog`

Port | Desc
--- | ---
`3000` | Optional: For [`hexo-browsersync`](https://github.com/hexojs/hexo-browsersync) to work
`4000` | Draft `localhost` port


### MacOS Users

#### `node_modules`

Since Docker for Mac uses a VM behind the scenes, referencing the current directory's `node_modules` folder may be very slow. If that's the case, delete the hosts (i.e. your laptop's) `node_modules` folder and the container has its own copy which will be faster.

#### `git`

I have tried to use the [`hexo-deployer-git`](https://github.com/hexojs/hexo-deployer-git) in the VM but struggled with the container accessing my `~.ssh` folder (from a permissions perspective) to access the private key for Github login. To work around this can manually deploy with following steps:

** Setup ** (do this once)

```bash
git clone --single-branch --branch gh-pages <git-repo> .deploy_git

# Example
git clone --single-branch --branch gh-pages git@github.com:martindsouza/talkapex.git .deploy_git

```

** Deploy **

```bash
hexo clean
hexo generate
rm -rf .deploy_git/*
cp -r public/* .deploy_git/
cd .deploy_git
git add *
git commit -m "Site updated"
git push
```

## Update

To update the image run: `docker pull martindsouza/hexo`

## Developing

If working on this image all the build scripts are registered as [Tasks](https://code.visualstudio.com/docs/editor/tasks) in [VSCode](https://code.visualstudio.com/)

