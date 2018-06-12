dir=~/dotfiles
files=".bashrc .vimrc .vim .gitconfig .tmux.conf"

cd $dir

for file in $files; do
    rm -rf ~/$file
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/$file
done

source ~/.bashrc
