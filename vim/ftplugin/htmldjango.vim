syn region djangoTagBlock start="\(^[\t ]*\)=" end="$" contains=djangoStatement,djangoFilter,djangoArgument,djangoTagError display containedin=ALLBUT,@djangoBlocks

inoreab <buffer>    % %<Space>%<left><Left>
inoreab {           {}<Left>

so ~/.dotfiles/vim/ftplugin/html.vim
so ~/.vimrc_after
