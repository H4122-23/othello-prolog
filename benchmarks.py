from time import sleep
from multiprocessing import Pool
from os import system

def benchmark(id: int):
    filename = "benchmarks-{}.txt".format(id)
    system("swipl othello.pl 1>{} 2 2".format(filename))

def main():
    with Pool() as pool:
        pool.map(benchmark, range(10))

if __name__ == '__main__':
    main()