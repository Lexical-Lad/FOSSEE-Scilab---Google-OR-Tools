#ifndef SCI_IOFUNCHEADER
#define SCI_IOFUNCHEADER

int getInt32FromScilab(int argNum, int* dest);
int getInt32MatrixFromScilab(int argNum, int *rows, int *cols, int **dest);
int getFixedSizeInt32MatrixFromScilab(int argNum, int rows, int cols, int **dest);
int returnInt32ToScilab(int itemPos, int retVal);
int returnInt32MatrixToScilab(int itemPos, int rows, int cols, int *dest);

int getInt64FromScilab(int argNum, long long* dest);
int getInt64MatrixFromScilab(int argNum, int *rows, int *cols, long long **dest);
int getFixedSizeInt64MatrixFromScilab(int argNum, int rows, int cols, long long **dest);
int returnInt64ToScilab(int itemPos, long long retVal);
int returnInt64MatrixToScilab(int itemPos, int rows, int cols, long long *dest);

int returnBooleanMatrixToScilab(int itemPos, int rows, int cols, BOOL *dest);

#endif //SCI_IOFUNCHEADER
