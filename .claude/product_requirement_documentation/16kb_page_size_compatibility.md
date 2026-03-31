# Make the repository 16KB page size compatible

This repository is a clone of https://github.com/QuickBirdEng/opencv-android which allows Android to use OpenCV directly without making any changes to native code, or having the hasstle of using OpenCV via JNI.

We want to make this repository compatible with 16KB page size. 

## What is 16KB page size?

By default, Android uses 4KB page size. However, some devices use 16KB page size. We want to make this repository compatible with 16KB page size.

## How to fix?

1. Understand the repository thoroughly and find out where the 4KB page size is being used and replace it with 16KB page size. 
2. Make this repository buildable and usable just as it is now. We should be able to just import this and get OpenCV working out of the box. 

## What is the expected output?

The repository should work on both 4KB and 16KB page size devices. And this repository has not been updated since 5 years. Clearly there are many changes done in the OpenCV main repository which should also be reflected here.

## References 
1. https://github.com/opencv/opencv/issues/27024
2. https://github.com/opencv/ci-gha-workflow/pull/246
3. https://github.com/opencv/opencv
4. https://github.com/opencv/opencv_contrib


