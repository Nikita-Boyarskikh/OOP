#include <stdio.h>

// Выводит num-ый круг матрицы А размером N*N
void print_circle(float *A, int N, int num) {
    for(int i = num; i < N - num; i++) printf("%-7.3f ", A[i*N + num]);  // Вывод левой стороны
    for(int i = num + 1; i < N - num; i++) printf("%-7.3f ", A[(N - num - 1)*N + i]);  // Вывод нижней стороны
    for(int i = N - 2 - num; i >= num; i--) printf("%-7.3f ", A[i*N + N - num - 1]);  // Вывод правой стороны
    for(int i = N - 2 - num; i > num; i--) printf("%-7.3f ", A[num*N + i]);  // Вывод верхней стороны
}

// Меняет значения 2-ух float переменных
void swapf(float *a, float *b) {
    if(*a == *b) return;
    *a += *b;
    *b = *a - *b;
    *a = *a - *b;
}

int main(int argc, char **argv) {

    int N;
    printf("Введите размер N матрицы A(N,N): ");
    scanf("%d", &N);
    float A[N][N];

    printf("Введите матрицу из %d на %d элементов:\n", N, N);

    // Ввод матрицы
    for(int i=0; i<N; i++)
        for(int j=0; j<N; j++)
            scanf("%f", &A[i][j]);

    printf("\nИсходная матрица:\n");

    // Вывод первоначальной матрицы
    for(int i=0; i<N; i++) {
        for(int j=0; j<N; j++)
            printf("%7.3f ", A[i][j]);
        printf("\n");
    }

    // Ищем максимальный элемент в каждом столбце и меняем с диагональным
    for(int j=0; j<N; j++) {
        float *max = &A[0][j];
        for(int i=1; i<N; i++)
            if(A[i][j] > *max)
                max = &A[i][j];
        swapf(max, &A[j][j]);
    }

    printf("\nМатрица после преобразований:\n");

    // Вывод преобразованной матрицы
    for(int i=0; i<N; i++) {
        for(int j=0; j<N; j++)
            printf("%7.3f ", A[i][j]);
        printf("\n");
    }

    printf("\nВывод матрица спиралью против часовой стрелки с первого:\n");

    // Вывод матрицы спиралью против часовой стрелки
    for(int i=0; i<N/2; i++) print_circle(&A[0][0], N, i);

    // Вывод центрального элемента, если матрица состоит из нечётного количества элементов
    if(N%2 != 0) printf("%7.3f", A[N/2][N/2]);
    printf("\n");

    return 0;
}
