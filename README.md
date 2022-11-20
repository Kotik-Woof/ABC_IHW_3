# АВС. ИДЗ №3. Вариант 18. БПИ213. Бабарикина Е. А.
## Условие задачи:  Разработать программу вычисления корня квадратного по итерационной формуле Герона Александрийского с точностью не хуже 0,05%.
## Планируемая оценка 5.

#### 1. Приведено решение задачи на C на планируемую оценку. Ввод данных осуществляется с клавиатры. Вывод данных осуществляется на дисплей.

    Ввод данных осуществляется с клавиатуры, а вывод на дисплей. 
    Посмотреть реализацию кода программы на языке C можно в файле IHW_3_CCP.c 
  
  
#### 2. В полученную ассемблерную программу, откомпилированную без оптимизирующих и отладочных опций, добавлены комментарии, поясняющие эквивалентное представление переменных в программе на C. То есть, для всех ссылок на память, включая и относительные адреса и регистры, указать имя переменной на языке C исходной программы.

    Посмотреть комментарии и код программы на языке ассемблера можно в файле IHW_3_asm.s
   
   
#### 3. Из ассемблерной программы убраны лишние макросы за счет использования при компиляции из C соответствующих аргументов командной строки и/или за счет ручного редактирования исходного текста ассемблерной программы

    Для этого я прописала в терминале следующую команду:
    $ gcc -O0 -Wall -masm=intel -S -fno-asynchronous-unwind-tables -fcf-protection=none source.c
    Она убирает всё лишнее
   
   
#### 4. Модифицированная ассемблерная программа отдельно откомпилирована и скомпонована без использования опций отладки.

    Для этого я прописала в терминале следующую команду:
    $ gcc source.c -o result  (внимательно посмотри, что используешь при компиляции)


#### 5. Представлено полное тестовое покрытие, дающее одинаковый результат
на обоих программах. Приведены результаты тестовых прогонов для обоих программ, демонстрирующие эквивалентность функционирования.**

    Тестирование проводилось методом "чёрного ящика". 
    Покрытие тестов можно посмотреть в файле BB_IHW_3.xlsx.
    Результаты тестов можно посмотреть в этом же файле.
    
    
#### 6. В реализованной программе необходимо использовать функции с передачей данных через параметры.
    
    Для решения задачи я использовала одну функцию с передачей данных через параметры - Sqrt
    
    
#### 7. Внутри функций необходимо использовать локальные переменные, которые при компиляции отображаются на стек.

    Локальные переменные были использованы. (Потом проверить)
  
  
#### 8. В ассемблерную программу в местах вызова функции добавить комментарии, описывающие передачу фактических параметров и перенос возвращаемого результата. При этом небходимо отметить, какая переменная или результат какого выражения соответствует тому или иному фактическому параметру.

    Все необходимы комментарии есть в приложенном файле.
    
    
 #### 9.  В ассемблерных функциях для каждого формального параметра необходимо добавить комментарии, описывающие связь между именами формальных параметров на языке C и регистрами (или значением на стеке), через которые эти параметры передаются.

     Всё было прокомментировано.
