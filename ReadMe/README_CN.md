# matCompare

## 语言

- [English](README.md)
- [中文](ReadMe/README_CN.md)

## 简介

matCompare是一个用于比较及合并.mat文件的Matlab App. Matlab自带的比较工具, 无法指定多个变量进行一次性合并, 只能每次选择单个变量进行合并. 单个变量合并完成后, 会自动重新运行比较, 才能合并下一个变量. 在变量较多时, 不方便使用. 针对这个问题, 本App修改了比较及合并的方式.

## 安装与运行

### 运行环境:

1. Matlab 2023a 及更高版本.
2. Matlab对应版本的Simulink.

### 安装步骤:

1. 运行Matlab
2. 使用Matlab 运行 安装文件 'matCompare.mlappinstall'
3. 在Matlab的 'App' 选项卡页面中, 找到 'matCompare', 点击运行.

## 使用方法

使用步骤:

1. 运行 'matCompare'
2. 点击图中按钮, 选择要比较的mat文件
   `<img width="704" alt="image" src="https://github.com/user-attachments/assets/cdfb4017-1b61-46b3-91d1-9cb558252140">`
3. 点击图中按钮, 选择另一个要比较的mat文件
   `<img width="704" alt="image" src="https://github.com/user-attachments/assets/9b089c0f-1b81-4521-a558-cd9ed6e01b28">`
4. 点击 '比较' 按钮
5. (可选) 点击 '仅显示差异项'
6. 点击选中比较表格中的行, 使用图中方框圈出来的按钮选择该行变量使用左侧mat数据还是右侧mat数据 (默认右侧数据)
   `<img width="704" alt="image" src="https://github.com/user-attachments/assets/ac19529b-9078-4c7f-ad43-4881f5485f0b">`
7. (可选) 双击比较表格中的行, 可打开matlab自带的比较工具visdiff, 比较选中变量的左右数据差异.
8. 选择完成后, 点击保存, 保存合并后的mat文件.
