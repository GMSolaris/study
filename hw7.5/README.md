Задача 1. Установите golang.

```
myagkikh@netology:~$ sudo apt install golang
myagkikh@netology:~$ go version
go version go1.15.15 linux/amd64
```

Задача 2. Знакомство с gotour.
Ознакомился

Задача 3. Написание кода.

Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные у пользователя, а можно статически задать в коде. Для взаимодействия с пользователем можно использовать функцию Scanf:
```go
package main
        
        import "fmt"
        
        import "math"
        
        func main() {
            fmt.Print("Enter value in foot: ")
            var input float64
            
            fmt.Scanf("%f", &input)           // округлим до 2х знаков в строке
            output := input * float64(0.3048) // точное значение 
            rOutput := math.Round(output)     // округлим до целого
            sOutput := fmt.Sprintf("( %.2f)", output)
            fmt.Println("Value in Meters:", rOutput, sOutput )    
        }
```

```
myagkikh@netology:~/hw7.5$ go run fut.go
Enter value in foot: 123
Value in Meters: 37 ( 37.49)
```


Напишите программу, которая найдет наименьший элемент в любом заданном списке, например x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}:
```go
 package main
        
        import "fmt"
        
        func main() {
            x := []int{48,2, 96,86,3,68,57,82,63,70,37,34,83,27,19,97,9,17,1}
            current := 0
            fmt.Println ("Список значений : ", x)
            for i, value := range x {
                if (i == 0) {
                   current = value 
                } else {
                    if (value < current){
                        current = value
                    }
                }
            }
            fmt.Println("Минимальное число : ", current)
        }    
```

```
myagkikh@netology:~/hw7.5$
go run find.go
Список значений :  [48 2 96 86 3 68 57 82 63 70 37 34 83 27 19 97 9 17 1]
Минимальное число :  1
```

Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть (3, 6, 9, …).
```go
package main
        
        import "fmt"
        
        
        func main() {
            
            for i := 1; i <= 100; i++ {
                if ((i-1)%10) ==0 {
                        fmt.Print(i-1," -> ")
                }            
                        
                if (i%3) == 0 {
                    fmt.Print(i,", ")
                    }
                if (i%10) ==0 {
                    fmt.Println()
                }
            }
        }
```

```
myagkikh@netology:~/hw7.5$ go run dev3.go
0 -> 3, 6, 9,
10 -> 12, 15, 18,
20 -> 21, 24, 27, 30,
30 -> 33, 36, 39,
40 -> 42, 45, 48,
50 -> 51, 54, 57, 60,
60 -> 63, 66, 69,
70 -> 72, 75, 78,
80 -> 81, 84, 87, 90,
90 -> 93, 96, 99,
```