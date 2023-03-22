sudo apt update && sudo apt upgrade -y
sudo apt-get install libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential
curl -Lo gcc-arm-none-eabi.tar.xz "https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_TOOLCHAIN_VERSION}/binrel/arm-gnu-toolchain-${ARM_TOOLCHAIN_VERSION}-x86_64-arm-none-eabi.tar.xz"
sudo mkdir /opt/gcc-arm-none-eabi
sudo tar xf gcc-arm-none-eabi.tar.xz --strip-components=1 -C /opt/gcc-arm-none-eabi

echo 'export PATH=$PATH:/opt/gcc-arm-none-eabi/bin' | sudo tee -a /etc/profile.d/gcc-arm-none-eabi.sh
git clone https://github.com/jhswartz/rk3229
cd rk3229

mkdir build
build() { log=$1; shift 1; (date; echo; time make $@) 2>&1 | tee $log; }
export BUILD=`readlink -f build`
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-

cd $BUILD
git clone https://github.com/OP-TEE/optee_os.git
cd optee_os
git checkout -b 3.7.0/rk3229 3.7.0
build build-optee.log CFG_TEE_BENCHMARK=n CFG_TEE_CORE_LOG_LEVEL=3 DEBUG=1 PLATFORM=rockchip-rk322x -j2
