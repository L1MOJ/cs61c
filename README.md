
# Lab3

## Exercise2

```c
int source[] = {3, 1, 4, 1, 5, 9, 0};
int dest[10];

int fun(int x) {
    return -x * (x + 1);
}

int main() {
    int k;
    int sum = 0;
    for (k = 0; source[k] != 0; k++) {
        dest[k] = fun(source[k]);
        sum += dest[k];
    }
    return sum;
}
```

- sourceK作为变量传入square函数中，t0/t1作为在Square函数中使用的变量要先入栈保护
- k存在t0，sum存在s0
- s1和s2分别指向source和dest的首元素
- s3代表偏移量，通过slli将t0的值乘4，再通过下面命令从source中读取数据
  :::tips
  add t1, s1, s3         lw t2, 0(t1)
  :::

- la是load address的缩写，伪指令
  :::tips
  la rd, label	-> 	auipc + addi
  :::

```
.data
source:
.word   3
.word   1
.word   4
.word   1
.word   5
.word   9
.word   0
dest:
.word   0
.word   0
.word   0
.word   0
.word   0
.word   0
.word   0
.word   0
.word   0
.word   0

.text
main:
addi t0, x0, 0
addi s0, x0, 0
la s1, source
la s2, dest
loop:
slli s3, t0, 2
add t1, s1, s3
lw t2, 0(t1)
beq t2, x0, exit
add a0, x0, t2
addi sp, sp, -8
sw t0, 0(sp)
sw t2, 4(sp)
jal square
lw t0, 0(sp)
lw t2, 4(sp)
addi sp, sp, 8
add t2, x0, a0
add t3, s2, s3
sw t2, 0(t3)
add s0, s0, t2
addi t0, t0, 1
jal x0, loop
square:
add t0, a0, x0
add t1, a0, x0
addi t0, t0, 1
addi t2, x0, -1
mul t1, t1, t2
mul a0, t0, t1
jr ra
exit:
add a0, x0, s0
add a1, x0, x0
ecall # Terminate ecall
```

## Exercise4

- 需要保护的寄存器ra,s0,s1。在调用另一个函数后保存在几个寄存器的值再进行函数操作

# Lab4

## Exercise1

- Always have to store the register's value in stack if they will change in the following jal/jalr
- add / sw 

## Exercise2

- Map the input value with the offset


# Lab5 Logism

- 熟悉了界面的基本门电路，组合电路
- 加法器和寄存器
- FSM状态机，根据真值表画出状态图



# Proj1

## Part A2

Part A2向我们介绍了一种加密方法Steganography[隐写术](https://zh.wikipedia.org/wiki/隐写术)。我们要完成的任务就是读取每个pixel

- 如果pixel的B通道的最后一位是0，则把该Pixel的三通道都置0
- 如果是1，则都置1
- argc参数个数, char **argv参数

## Part B The Game of Life

**二级指针**

- 一个指针 ptrold 加(减)一个整数 n 后，结果是一个新的指针 ptrnew，ptrnew 的类型和 ptrold 的**类型相同**，ptrnew **所指向的类型和 ptrold 所指向的类型也相同**。ptrnew 的值将比 ptrold 的值增加(减少)了 n 乘 **sizeof(ptrold 所指向的类型)**个字节

```c
Color *evaluateOnePixel(Image *image, int row, int col)
{
    //YOUR CODE HERE
    Color **p = image->image;
    Color *encoded = (Color*) malloc(sizeof(Color));
    p += (col + row * (image->cols));
    int LSB = (*p)->B & 1;
    encoded->B = encoded->G = encoded->R = LSB * 255;
    return encoded;
}
```

p是二级指针，指向的类型是**指向Color的指针，**所以p加上整数后p的值会增加n✖️sizeof(Color*),即往前移动了n个格子

- **做的时候发现直接用p[x][y]取值不对，等会想想**

# Proj2-su20

## Part A

- 如果在调用另一个函数时，有重复使用的寄存器一定要先入栈
  - ![10c02cc4899430476fb49f71c87d486.jpg](https://cdn.nlark.com/yuque/0/2023/jpeg/5357310/1678026027345-a117384c-2eeb-4078-9c20-2ed5571a1909.jpeg#averageHue=%23fefefc&clientId=u43dadcf0-dc3e-4&from=drop&id=u748e6ee6&name=10c02cc4899430476fb49f71c87d486.jpg&originHeight=798&originWidth=1712&originalType=binary&ratio=1&rotation=0&showTitle=false&size=264585&status=done&style=none&taskId=u3c5f8ab2-ab0f-4781-8777-9cf8d16a3d6&title=)否则会出现error，目前还没搞明白为什么， 明明在另一个函数里已经重新赋值了

## Part B

- Preserve each **Saved Registers** before **changing their values** (s0-s7)

