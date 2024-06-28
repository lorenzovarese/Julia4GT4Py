#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

#define ARRAY_SIZE 1000000

int main() {
    // Allocate memory for arrays
    double *A = (double*)malloc(ARRAY_SIZE * sizeof(double));
    double *B = (double*)malloc(ARRAY_SIZE * sizeof(double));
    double *C = (double*)malloc(ARRAY_SIZE * sizeof(double));

    // Initialize arrays
    for (int i = 0; i < ARRAY_SIZE; i++) {
        A[i] = i * 1.0;
        B[i] = (ARRAY_SIZE - i) * 1.0;
    }

    // Perform addition of arrays A and B and store the result in array C
    #pragma omp parallel for
    for (int i = 0; i < ARRAY_SIZE; i++) {
        C[i] = A[i] + B[i];
    }

    // Verify the results
    for (int i = 0; i < ARRAY_SIZE; i++) {
        if (C[i] != ARRAY_SIZE) {
            printf("Error at index %d: %f\n", i, C[i]);
            free(A);
            free(B);
            free(C);
            return 1;
        }
    }

    printf("All results are correct.\n");

    // Free allocated memory
    free(A);
    free(B);
    free(C);

    return 0;
}