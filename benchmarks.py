from argparse import ArgumentParser
from os import system
from multiprocessing import Pool
from csv import DictWriter

def run(filename: str, x: int, o: int):
    system("swipl othello.pl 1>{} {} {}".format(filename, x, o))

def process_results(filename: str):

    # Read last 5 lines of the file 
    with open(filename, "r") as f:
        lines = f.readlines()[-5:]
    return {
        "execution_time": lines[-2].split(":")[-1].strip(),
        "x_score": lines[0].split(":")[-1].strip(),
        "o_score": lines[1].split(":")[-1].strip(),
    }

def main():
    # Define the command line arguments
    parser = ArgumentParser(description="Runs benchmarks and creates a report for the results.")
    parser.add_argument("-n", "--number-of-runs", type=int, default=10)
    parser.add_argument("-o", "--algorithm-of-player-o", type=int, default=2)
    parser.add_argument("-x", "--algorithm-of-player-x", type=int, default=2)

    # Parse the command line arguments
    args = parser.parse_args()

    # Run the benchmarks
    with Pool() as pool:
        arguments = [
            ("logs/benchmarks-{}.txt".format(i), args.algorithm_of_player_x, args.algorithm_of_player_o)
            for i in range(args.number_of_runs)
        ]
        pool.starmap(run, arguments)

    # Create the report
    filename = "benchmarks_x{}_o{}.csv".format(
        args.algorithm_of_player_x, args.algorithm_of_player_o
    )

    with open(filename, "w") as f:
        # Create dict writer
        writer = DictWriter(f, fieldnames=["x_score", "o_score", "execution_time"])
        writer.writeheader()

        for filename, _, _ in arguments:
            results = process_results(filename)
            writer.writerow(results)



if __name__ == '__main__':
    main()