#include <stdio.h>
#include <stdlib.h>

// вычисление корня по итерационному алгоритму Герона
double Sqrt(double number) {
    double result; // предполагаемое значение корня числа.;
    if (number >= 1) {
        result = number / 2;
        for (int i = 0; i < (int) (number * 0.5); i++) {
            result = 0.5 * (result + (number / result));
        }
    } else {
        result = number;
        for (int i = 0; i < 50; i++) {
            result = 0.5 * (result + (number / result));
        }
    }
    return result;
}

// ввод вещественого неотрицательного числа
double inputNumber() {
    char buf[10];// временная переменная
    char is_correct;     // проверка на корректность
    double number;         // число
    printf("number = ");
    do {
        gets(buf);
        number = atof(buf);
        if (number == 0 && buf[0] != '0') {
            printf("You input a not number.\nnumber = ");
            is_correct = 'F';
        } else if (number < 0) {
            printf("You should input a pusitive number\nnumber = ");
            is_correct = 'F';
        } else {
            is_correct = 'T';
        }
    } while (is_correct == 'F');

    return number;
}

int main() {
    printf("This program counts the square root of the number.\n");
    double number = inputNumber();
    double result = Sqrt(number);
    printf("\nResult = %f", result);
    printf("\nFinish.\n");
    return 0;
}