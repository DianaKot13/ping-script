import subprocess
import time

def ping(host):
    try:
        output = subprocess.check_output(
            ['ping', '-c', '1', host],
            stderr=subprocess.STDOUT,
                universal_newlines=True
        )
        for line in output.split('\n'):
            if 'time=' in line:
                return float(line.split('time=')[1].split(' ')[0])
    except subprocess.CalledProcessError:
        return None

def main():
    address = input("Введите адрес для пинга: ")
    consecutive_failures = 0
    max_consecutive_failures = 3
    max_ping_time = 100  
    while True:
        response_time = ping(address)
        if response_time is None:
            consecutive_failures += 1
            if consecutive_failures >= max_consecutive_failures:
                print("Не удается выполнить пинг в течение 3 последовательных попыток.")
                consecutive_failures = 0
        else:
            consecutive_failures = 0
            if response_time * 1000 > max_ping_time:  
                print(f"Время пинга {response_time * 1000:.2f} мс превышает 100 мс.")
        
        time.sleep(1)

if __name__ == "__main__":
    main()
