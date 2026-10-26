#include <iostream>
using namespace std; 

template <typename T>
class LinkedList {
public:
  struct Node {
    T data;
    Node* next;
    Node* prev;

    Node(T d) {
    data = d; 
    next = nullptr;
    prev = nullptr;
  }
  };

  LinkedList() {
    head = nullptr;
    tail = nullptr; 
    count = 0;
  }

  LinkedList(const LinkedList& list) 
  : count(0), tail(nullptr), head(nullptr) {
    for (Node* curr = list.head; curr != nullptr; curr = curr->next) {
      Node* newNode = new Node(curr->data);
      newNode->next = nullptr; 
      newNode->prev = tail;
      if (head == nullptr) {
        head = newNode;
      } else {
        tail->next = newNode;
      }
      tail = newNode; 
    }
  }

  LinkedList<T>& operator=(const LinkedList& list) {
    if (this != &list) {
      while (head != nullptr) {
        Node* toBeDeleted = head;
        head = head->next;
        delete toBeDeleted; 
      }
      count = list.count;
      tail = nullptr; 

     for (Node* curr = list.head; curr != nullptr; curr = curr->next) {
      Node* newNode = new Node(curr->data);
      newNode->next = nullptr; 
      newNode->prev = tail;
      if (head == nullptr) {
        head = newNode;
      } else {
        tail->next = newNode;
      }
      tail = newNode;
      }
    }
    return *this;
  }

  ~LinkedList() {
    while (this->head != nullptr) {
      Node* toBeDeleted = this->head;
      this->head = this->head->next;
      delete toBeDeleted;
    }
    tail = nullptr;
    count = 0; 
  }

  void AddHead(const T& value) {
    Node* newNode = new Node(value);
    if (head != nullptr) {
      head->prev = newNode;
      newNode->next = head;
      head = newNode;
    } else {  
      head = newNode;
      tail = newNode;  
    }
    count++;
  }

  void AddTail(const T& value) {
    Node* newNode = new Node(value);
    if (tail !=nullptr) {
      tail->next = newNode; 
      newNode->prev = tail;
      tail = newNode; 
      tail->next = nullptr;
    } else {
      tail = head = newNode; 
    }
    count++;
  }

  void AddNodesHead(const T* ArrPtr, unsigned int count) {
    for (unsigned int i = count; i > 0; i--) {
      AddHead(ArrPtr[i-1]);
    }
  }
  
  void AddNodesTail(const T* ArrPtr, unsigned int count) {
    for (unsigned int i = 0; i < count; i++) {
      AddTail(ArrPtr[i]);
    }
  } 

  void PrintForward() const {
    if (head != nullptr) {
      for (Node* curr = head; curr != nullptr; curr = curr->next) {
        T toPrint;
        curr->data = toPrint; 
        cout << toPrint << endl; 
      }
    }
  }

  void PrintReverse() const {
    if (tail != nullptr) {
      for (Node* curr = tail; curr != nullptr; curr = curr->prev) {
        T toPrint;
        curr->data = toPrint;
        cout << toPrint << endl;
      }
    }
  }

  Node* GetHead() {
    return head;
  }

  const Node* GetHead() const {
    return head;
  }

  Node* GetTail() {
    return tail;
  }

  const Node* GetTail() const {
    return tail;
  }

  unsigned int GetCount() const {
    return count; 
  }

private:
  Node* head;
  Node* tail;
  unsigned int count;   
};





