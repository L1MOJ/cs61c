#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* your code here */
    node *slow = head;
    node *fast = head;
    while(fast != NULL) {
        fast = fast->next->next;
        slow = slow->next;
        if(slow == fast) {
            return 1;
        }
    }
    return 0;
}