# 1. CÁC HÀM HỖ TRỢ BỘ CỘNG
def nfax(a_bit, b_bit, cin):
    sum_bit = a_bit ^ b_bit ^ cin 
    cout = a_bit & b_bit          
    return sum_bit, cout

def exact_fa(a_bit, b_bit, cin):
    sum_bit = a_bit ^ b_bit ^ cin 
    cout = (a_bit & b_bit) | (a_bit & cin) | (b_bit & cin) 
    return sum_bit, cout

def adder8_hybrid(x, y, use_approx=True):
    x_bits = [(x >> i) & 1 for i in range(8)]
    y_bits = [(y >> i) & 1 for i in range(8)]
    
    sum_bits = [0] * 8
    carry = 0 
    
    for i in range(8):
        if use_approx and i < 2: 
            sum_bits[i], carry = nfax(x_bits[i], y_bits[i], carry) 
        else: 
            sum_bits[i], carry = exact_fa(x_bits[i], y_bits[i], carry) 
            
    final_sum = sum(sum_bits[i] << i for i in range(8))
    if final_sum >= 128:
        final_sum -= 256
    return final_sum

# 2. LỚP PROCESSING ELEMENT (PE)
class PEMAC:
    def __init__(self, use_approx=True):
        self.use_approx = use_approx
        self.a_out = 0   
        self.b_out = 0   
        self.sum_out = 0 
        self.next_a_out = 0
        self.next_b_out = 0
        self.next_sum_out = 0

    def compute_next_state(self, a_in, b_in, clear_acc):
        mult_result = a_in * b_in 
        next_sum_unsigned = adder8_hybrid(self.sum_out, mult_result, self.use_approx) 
        
        self.next_a_out = a_in 
        self.next_b_out = b_in 
        if clear_acc:
            self.next_sum_out = 0 
        else:
            self.next_sum_out = next_sum_unsigned 

    def update_registers(self):
        self.a_out = self.next_a_out
        self.b_out = self.next_b_out
        self.sum_out = self.next_sum_out

# 3. LỚP SYSTOLIC ARRAY 4x4
class SystolicArray4x4:
    def __init__(self, use_approx=True):
        self.pes = [[PEMAC(use_approx) for _ in range(4)] for _ in range(4)]

    def clock_cycle(self, a_inputs, b_inputs, clear_acc):
        for i in range(4):
            for j in range(4):
                a_in = a_inputs[i] if j == 0 else self.pes[i][j-1].a_out
                b_in = b_inputs[j] if i == 0 else self.pes[i-1][j].b_out
                self.pes[i][j].compute_next_state(a_in, b_in, clear_acc)

        for i in range(4):
            for j in range(4):
                self.pes[i][j].update_registers() 

    def get_outputs(self):
        return [[self.pes[i][j].sum_out for j in range(4)] for i in range(4)]

# 4. ĐOẠN MÃ CHẠY THỬ (TEST BENCH)
if __name__ == "__main__":
    # Khởi tạo mảng Systolic 4x4
    # Đặt use_approx=False để xem kết quả tính toán chính xác tuyệt đối
    # Đặt use_approx=True để xem tác động của bộ cộng lai (có sai số nhẹ)
    sys_array = SystolicArray4x4(use_approx=False) 

    # Định nghĩa ma trận đầu vào A (4x4)
    matrix_A = [
        [1, 2, 3, 4],
        [2, 1, 1, 1],
        [0, 1, 0, 2],
        [1, 0, 1, 0]
    ]

    # Định nghĩa ma trận đầu vào B (4x4)
    matrix_B = [
        [1, 0, 2, 0],
        [0, 1, 0, 1],
        [1, 1, 1, 0],
        [0, 0, 1, 1]
    ]

    print("=== BẮT ĐẦU MÔ PHỎNG NHÂN MA TRẬN ===")
    
    # Một mảng NxN cần khoảng 3N-2 chu kỳ để hoàn thành tính toán.
    # Với N=4, cần 10 chu kỳ. Chúng ta chạy 12 chu kỳ để thấy kết quả ổn định cuối cùng.
    TOTAL_CYCLES = 12 

    for t in range(TOTAL_CYCLES):
        # Mảng chứa tín hiệu đầu vào tại chu kỳ t
        a_in_current = [0, 0, 0, 0]
        b_in_current = [0, 0, 0, 0]

        # Nạp dữ liệu có độ trễ (Skewing)
        for i in range(4):
            # Hàng i của A trễ i chu kỳ
            if 0 <= t - i < 4:
                a_in_current[i] = matrix_A[i][t - i]
                
        for j in range(4):
            # Cột j của B trễ j chu kỳ
            if 0 <= t - j < 4:
                b_in_current[j] = matrix_B[t - j][j]

        # Đưa tín hiệu vào mảng Systolic và chạy 1 chu kỳ clock
        sys_array.clock_cycle(a_in_current, b_in_current, clear_acc=False)

        # In kết quả sau mỗi chu kỳ
        print(f"\n--- Chu kỳ {t + 1} ---")
        print(f"Input A đưa vào: {a_in_current}")
        print(f"Input B đưa vào: {b_in_current}")
        print("Trạng thái ma trận C hiện tại:")
        for row in sys_array.get_outputs():
            print(f"  {row}")

    print("\n=== KẾT QUẢ CUỐI CÙNG ===")
    print("Ma trận C (A x B) là:")
    for row in sys_array.get_outputs():
        print(row)