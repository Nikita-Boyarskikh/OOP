#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Элемент двусвязного списка
struct node {
    struct node* next;
    struct node* pref;
    unsigned int data;
};

// Читает строку из STDIN, записывает в массив *numbers длиной *num и
// возвращает количество прочитанных чисел, или -1 в случае ошибки работы с памятью,
// или -2 в случае ошибки преобразования, или -3 в случае ошибки программиста :)
int str2numarray(const char* str, size_t str_size, unsigned int **numbers, size_t *size);

// Принимает строку и индексы from, to и возвращает число из символов в интервале [from, to)
// или -1 в случае неверных границ, или -2 в случае ошибки преобразования числа в строку,
// или -3 в случае переполнения разрядной сетки
long int str2num(char* str, size_t from, size_t to);

// Создаёт очередь из массива numbers, записывает в first и last границы очереди,
// возвращает true/false в зависимости от успешности операции
int create_queue(struct node** first, struct node** last, unsigned int* numbers, size_t size);

// Удаляет очередь от first до last
void delete_queue(struct node* first, struct node* last);

int main(int argc, char **argv)
{
    size_t size = 256;
    unsigned int* numbers = (unsigned int*)malloc(size*sizeof(unsigned int));
    if(! numbers) {
        printf("Не удалось выделить память!\n");
        return 1;
    }
    
    // Ввод чисел
    printf("Введите строку чисел:\n");
    char str[255], lc;
    if(! (scanf("%255[^\n]%c", &str[0], &lc) == 2 && lc == '\n') ) {
        printf("Ошибка: ошибка ввода!\n");
        return 1;
    }
    int num = str2numarray(&str[0], strlen(str), &numbers, &size);
    if( num < 0 ) {
        printf("Ошибка %d: неправильные данные!\n", -num);
        return 1;
    }
    
    // Создание очереди
    struct node* first = NULL;
    struct node* last = NULL;
    if( ! create_queue(&first, &last, numbers, num) ) {
        printf("Ошибка: не удалось создать очередь!\n");
        return 1;
    }
    
    // Ввод границ диапазона
    long int a = -1, b = -1;
    printf("Введите границы диапазона: ");
    if( scanf("%ld %ld", &a, &b) != 2 ) {
        printf("Ошибка: ошибка ввода!\n");
        return 1;
    }
    if( a < 0 || b < 0 ) {
        printf("Ошибка: неверные границы!\n");
        return 1;
    }

    // Посчёт чисел, попавших в диапазон
    struct node* cur = last;
    size_t counter = 0;
    while(cur != NULL) {
        if(a <= cur->data && cur->data <= b) counter++;
        cur = cur->pref;
    }
    printf("Количество чисел, входящий в диапазон [%ld, %ld]: %zu\n", a, b, counter);
    
    // Очистка выделенной памяти
    delete_queue(first, last);
    free(numbers);
    
    return 0;
}

// Читает строку str, записывает числа из неё в массив *numbers длиной *num и
// возвращает количество прочитанных чисел, или -1 в случае ошибки работы с памятью,
// или -2 в случае ошибки преобразования, или -3 в случае ошибки программиста :)
int str2numarray(const char *str, size_t str_size, unsigned int **numbers, size_t *size)
{
    if( ! str || ! numbers || ! *numbers || ! size ) return -3;
    size_t i = 0;
    char buf[6], ch;
    size_t len = 0;
    unsigned int *nums = *numbers;
    for(size_t j = 0; j <= str_size; j++) {
        ch = str[j];
        // Встречен пробел, запысываем накопленный буфер
        if( ch == ' ' ) {
            // Пропускаем пробелы
            if( len == 0 ) continue;
            // Реаллоцируем память
            if( *size < i ) {
                *size *= 2;
                free(nums);
                unsigned int *tmp = NULL;
                if( ! (tmp = (unsigned int*)malloc(*size * sizeof(unsigned int))) ) return -1;
                nums = tmp;
                *numbers = tmp;
            }
            // Переводим строку в число
            long int new_num = str2num(&buf[0], 0, len);
            // Обрабатываем ошибки
            if(new_num < 0) {
                return new_num;
            } else {
                nums[i] = (unsigned int)new_num;
            }
            i++;
            len = 0;
        }
        // Встречен конец строки, дописываем остаток
        else if(ch == '\0') {
            if(len == 0) return (int) i;
            else {
                // Переводим строку в число
                long int new_num = str2num(&buf[0], 0, len);
                // Обрабатываем ошибки
                if(new_num < 0) {
                    return new_num;
                } else {
                    nums[i] = (unsigned int)new_num;
                }
            }
            break;
        // Накапливаем в буфер цифры
        } else {
            buf[len] = ch;
            len++;
            if( len > 5 ) return -2;
        }
    }
    return (int)i + 1;
}

// Принимает строку и индексы from, to и возвращает число из символов в интервале [from, to)
// или -1 в случае переполнения разрядной сетки, или -2 в случае ошибки преобразования числа в строку,
// или -3 в случае неверных границ
long int str2num(char* str, size_t from, size_t to)
{
    if( to - from > 5 ) return -3;
    unsigned int num = 0;
    for(size_t i = from; i < to; i++) {
        if( str[i] - '0' > 9 || str[i] - '0' < 0 ) return -2;
        num = num * 10 + (str[i] - '0');
    }
    if( num > 65535 ) return -1;
    return num;
}

// Создаёт очередь из массива numbers, записывает в first и last границы очереди,
// возвращает true/false в зависимости от успешности операции
int create_queue(struct node** first, struct node** last, unsigned int* numbers, size_t size)
{
    // Создаём первый элемент
    struct node* cur;
    if( ! (cur = (struct node*)malloc(sizeof(struct node))) ) return 0;
    *first = cur;
    cur->pref = NULL;
    cur->data = numbers[0];
    if( ! (cur->next = (struct node*)malloc(sizeof(struct node))) ) {
        free(cur);
        return 0;
    }
    cur = cur->next;
    cur->pref = *first;

    // Создаём промежуточные элементы
    for(size_t i = 1; i < size - 1; i++)
    {
        struct node* pref = cur;
        cur->data = numbers[i];
        if( ! (cur->next = (struct node*)malloc(sizeof(struct node))) ) {
            delete_queue(*first, cur);
            return 0;
        }
        cur = cur->next;
        cur->pref = pref;
    }
    
    *last = cur;
    cur->data = numbers[size - 1];
    cur->next = NULL;
    return 1;
}

// Удаляет очередь от first до last
void delete_queue(struct node* first, struct node* last)
{
    if(first == NULL || last == NULL) return;
    while(first != last) {
        first = first->next;
        free(first->pref);
    }
    free(last);
}
