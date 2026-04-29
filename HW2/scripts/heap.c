#include <stdlib.h>

void a(void){
    malloc(4000);
}
void b(void){
    malloc(2000);
    a();
}
void c(void){
    malloc(8000);
    b();
    a();
    b();
}
void d(void){
    malloc(16000);
    b();
    c();
    a();
    c();
    a();
}
void e(void){
    malloc(1000);
    b();
    a();
    a();
    c();
    d();
}
void h(void){
    malloc(1000);
    d();
    c();
    c();
    d();
    e();
}
int main(void){
    int i;
    int* arr[10];
    for (i = 0; i < 10; i++) {
        arr[i] = malloc(1000);
    }
    e();
    b();
    a();
    c();
    d();
    for (i = 0; i < 10; i++) {
        free(arr[i]);
    }
    return 0;
}