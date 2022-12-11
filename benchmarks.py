from time import sleep
from multiprocessing import Pool
from os import system

def benchmark(id: int):
    filename = "logs/benchmarks-{}.txt".format(id)
    system("swipl othello.pl 1>{} 5 6".format(filename))

def main():
    with Pool() as pool:
        pool.map(benchmark, range(10))

if __name__ == '__main__':
    main()