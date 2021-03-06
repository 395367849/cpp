#!/bin/sh

#sh release.sh

PrintHelp()
{
  echo "hot to use: 命令行切换到release目录下，执行sh release.sh"
}

binpath=/home/cpp/bin
releasePath="/home/cpp/release"
project=`pwd |cut -d / -f 6`
exe="$binpath"/"$project"

if [ -d "$binpath" ] ;then
  mkdir -p $binpath
fi


#重编
sh rebuild.sh

if [ ! -f "$exe" ] ;then
  echo "err:target file not exist"
  exit 0
fi

version=`$exe -version`
patchpath=$releasePath/"$project""$version"

if [ "$version" = "" ] ;then
  echo "version err"
  exit 0
fi

#删除原有，重建目录
rm -rf "$patchpath"
mkdir -p "$patchpath"


cp $exe $patchpath
cp appid.cnf $patchpath

echo "Ok, the version is "$project""$version""



