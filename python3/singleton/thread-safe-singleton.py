from threading import RLock

class Singleton(type):
    _instance = None
    _lock = RLock()

    def __call__(cls, *args, **kwargs):
        with cls._lock:
            if not cls._instance:
                cls._instance = super().__call__(*args, **kwargs)
        return cls._instance

class SingletonClass(metaclass=Singleton):
    def __init__(self, name):
        self.name = name

def main():
    obj1 = SingletonClass("A")
    print(obj1.name)
    obj2 = SingletonClass("B")
    print(obj2.name)

if __name__ == "__main__":
    main()
