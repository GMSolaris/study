1.
2. 
3.

Устанавливаем vagrant, virtualbox. Отключаем стоковый гипервизор в win10 перезапускаемся.

4. Меняем конифиг 
```
Vagrant.configure("2") do |config|
  config.vm.box = "debian/buster64"
```
  
Запускаем vagrant up

5. два ядра, 512мб оперативной памяти, 20gb дисковая, сеть прокинута через NAT

6. Для кастомизации ресурсов машины надо залезть в конфиг и поправить данные параметры:
```
config.vm.provider "virtualbox" do |v|  
	v.memory = 1024  //оперативаная память
	v.cpus = 2end	 //кол-во ядер
```

7. запускаем консоль vatrant ssh

8. Открываем man bash делаем поиск по /history находим нужный параметр. 595 строка

HISTSIZE
The  number of commands to remember in the command history (see HISTORY below).
If the value is 0, commands are not saved in the history list.
Numeric values less than zero result in every command being saved on the history list (there is no limit).
The shell sets the default value to 500 after reading any startup files.

директива ingoreboth определяет, что все команды введенные в оболочке и начинающиеся с пробела или повторяющиеся с предыдущеми введенными не будут сохранятся в историю.
A value of ignoreboth is shorthand for ignorespace and ignoredups.

9. Не совсем ясен вопрос, соответственно и так же ответ. Фигурные скобки используются в bash в нескольких местах. Например:
```
{}

    { list; }

    Placing a list of commands between curly braces causes the list to be executed in the current shell context. No subshell is created. The semicolon (or newline) following list is required. 
```
Так же фигурные скобки используются для замены выражений. Кусок мана:
```
Замена выражений в фигурных скобках

Замена выражений в фигурных скобках - это механизм генерации произвольных

строк. Он аналогичен подстановке имен файлов, но генерируемые имена

не обязательно должны существовать. Шаблоны в фигурных скобках имеют вид

необязательного префикса, за которым идет набор строк через запятую в фигурных

скобках, после чего - необязательный суффикс. Префикс добавляется в начало

каждой строки, содержащейся в фигурных скобках, а затем к каждой полученной

так (слева направо) строке добавляется суффикс.

Выражения в фигурных скобках могут быть вложенными. Результаты каждой замены не

сортируются; порядок слева направо сохраняется. Например, конструкция

a{d,c,b}e заменяется на 'ade ace abe'.

Замена выражений в фигурных скобках выполняется перед любыми другими заменами, и

в результате сохраняются все символы, имеющие специальное значение для других

замен. Эта замена - строго текстуальная. Командный интерпретатор bash никак

не учитывает контекст подстановки или текст в фигурных скобках.

Корректное выражение в фигурных скобках должно содержать незамаскированные

открывающую и закрывающую фигурную скобку и, по крайней мере, одну незамаскированную

запятую. Любое некорректное выражение в фигурных скобках остается неизменным.

Символ { или , может маскироваться обратной косой для предотвращения его

интерпретации на этапе замены выражений в фигурных скобках.

Эта конструкция обычно используется для сокращенной записи группы строк с

общим префиксом, более длинным чем в представленном выше примере:


              mkdir /usr/local/src/bash/{old,new,dist,bugs}

    или


              chown root /usr/{ucb/{ex,edit},lib/{ex?.?*,how_ex}}

Замена выражений в фигурных скобках вносит небольшое рассогласование

с историческими версиями sh. Командный интерпретатор sh не рассматривает

открывающую и закрывающую фигурные скобки в слове специальным образом

и просто сохраняет их. Командный интерпретатор bash удаляет фигурные скобки

из слова при замене. Например, слово, введенное в sh как file{1,2},

остается без изменений. Это же слово заменяется парой слов

file1 file2 после замены выражения в фигурных скобках в bash.

Если требуется полная совместимость с sh, командный интерпретатор bash

надо запускать с опцией +B или отключать с помощью опции

+B команды set (см. раздел

"ВСТРОЕННЫЕ КОМАНДЫ ИНТЕРПРЕТАТОРА" ниже). 
```

10. Используя замену выражений создать 100 000 файлов можно командой
touch {1..100000}.txt 

получаем 100 000 файлов с именами 1.txt 2.txt 3.txt и тд
Создать таким образом 300 000 файлов не получится, потому что длинна аргумента ограничена, получим ошибку 
-bash: /usr/bin/touch: Argument list too long 

11. 
 [[ expression ]]
 Return  a  status  of 0 or 1 depending on the evaluation of the conditional expression expression.
 Expressions are composed of the primaries described below under CONDITIONAL EXPRESSIONS.
 Word splitting and pathname expansion are not performed on the words between the [[ and ]];
 tilde expansion, parameter and variable expansion, arithmetic expansion, command substitution, process substitution, and  quote  removal  are  performed.
 Conditional operators such as -f must be unquoted to be recognized as primaries.
 When used with [[, the < and > operators sort lexicographically using the current locale
 
Своими словами данная команда проверяет наличие директории по указанному пути, и в случае наличия возвращает 1, в противном 0. Пример использования простой bash скрипт.
```
kvazik@myagkikh:/mnt/c/gmsolaris/study$ if [[ -d /tmp ]];then echo "folder exist"; else echo "folder not found"; fi
     folder exist	 
kvazik@myagkikh:/mnt/c/gmsolaris/study$ if [[ -d /tmp2 ]];then echo "folder exist"; else echo "folder not found"; fi
     folder not found                                
```
 
 12. Добавляем путь. Для этого редактируем файл
 ```
 # ~/.bashrc: executed by bash(1) for non-login shells.
 # see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
 # for examples
 PATH=/tmp/new_path_bash:$PATH
 ```
 
 
 12. Запуск задач с помощью at и batch отличается тем, что запуск at выполняет задачу в определенное время. В то время как batch запускает задачу когда загрузка системы становится меньше чем определенное значение. (судя по ману) сам такое не запускал никогда.
 
 