debug history
1. "sync text error"
    原因：yacc檔裡沒有定義expr後面接expr的語法
    解決方法：新增一個grammar
    ```
    stmt : expr stmt
        |
        ;
    ```

2. 傳到judge沒有按照規定改檔名
    in A.l`#include "y.tab.h"`需更正為`#include "[yacc檔名].tab.h"`


