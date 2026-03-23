
def nfax(a_bit, b_bit, cin):
    sum_bit = a_bit ^ b_bit ^ cin
    cout = a_bit & b_bit 
    return sum_bit, cout

def exact_fa(a_bit, b_bit, cin):
    sum_bit = a_bit ^ b_bit ^ cin
    cout = (a_bit & b_bit) | (a_bit & cin) | (b_bit & cin)
    return sum_bit, cout

def adder8_hybrid(x, y, use_approx=True):
    sum_bits = [0] * 8
    carry = 0
    for i in range(8):
        x_bit = (x >> i) & 1
        y_bit = (y >> i) & 1
        if use_approx and i < 2:
            sum_bits[i], carry = nfax(x_bit, y_bit, carry)
        else:
            sum_bits[i], carry = exact_fa(x_bit, y_bit, carry)
            
    final_sum_unsigned = sum(sum_bits[i] << i for i in range(8))
   
    return final_sum_unsigned - 256 if final_sum_unsigned >= 128 else final_sum_unsigned

# ==========================================
# 2.  PROCESSING ELEMENT (PE)
# ==========================================
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
        next_sum = adder8_hybrid(self.sum_out, mult_result, self.use_approx)
        self.next_a_out = a_in
        self.next_b_out = b_in
        self.next_sum_out = 0 if clear_acc else next_sum

    def update_registers(self):
        self.a_out = self.next_a_out
        self.b_out = self.next_b_out
        self.sum_out = self.next_sum_out

# ==========================================
# 3. SYSTOLIC ARRAY 4x4
# ==========================================
class SystolicArray4x4:
    def __init__(self, use_approx=True):
       
        self.pes = [[PEMAC(use_approx) for _ in range(4)] for _ in range(4)]

    def clock_cycle(self, a_inputs, b_inputs, clear_acc=False):
        
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

# ==========================================
# 4. (TESTBENCH)
# ==========================================
def run_test_case(matrix_A, matrix_B, test_name, expected_matrix=None, use_approx=True):
    print(f"\n{'='*50}")
    print(f" {test_name} ")
    print(f" Cấu hình phần cứng: {'Approximate Adder (Sai số)' if use_approx else 'Exact Adder (Chính xác)'}")
    print(f"{'='*50}")
    
    sys_array = SystolicArray4x4(use_approx=use_approx)
    
   
    TOTAL_CYCLES = 12 

    for t in range(TOTAL_CYCLES):
        a_in_current = [0, 0, 0, 0]
        b_in_current = [0, 0, 0, 0]

        # Nạp dữ liệu chéo (Data Skewing)
        for i in range(4):
            if 0 <= t - i < 4:
                a_in_current[i] = matrix_A[i][t - i]
                
        for j in range(4):
            if 0 <= t - j < 4:
                b_in_current[j] = matrix_B[t - j][j]

        sys_array.clock_cycle(a_in_current, b_in_current, clear_acc=False)

   
    actual_output = sys_array.get_outputs()
    
    print("\n[ KẾT QUẢ TỪ SYSTOLIC ARRAY ]")
    for row in actual_output:
        print(" [" + ", ".join(f"{val:4}" for val in row) + " ]")

  
    if expected_matrix:
        print("\n[ KẾT QUẢ KỲ VỌNG (LÝ THUYẾT) ]")
        for row in expected_matrix:
            print(" [" + ", ".join(f"{val:4}" for val in row) + " ]")
            
      
        is_match = actual_output == expected_matrix
        print(f"\n=> ĐÁNH GIÁ: {'KHỚP HOÀN TOÀN' if is_match else 'CÓ SAI SỐ (Do Approximate Adder hoặc Lỗi)'}")

if __name__ == "__main__":
  
    USE_APPROX = False 

    # --- TEST CASE 1: Ma trận ngẫu nhiên ---
    A1 = [[1, -2, 3, 0], [-1, 2, -3, 1], [2, 0, -1, 4], [-2, 1, 1, -1]]
    B1 = [[1, 0, -1, 2], [2, -1, 0, 0], [-2, 1, 1, 1], [1, 2, -1, -2]]
  
    Expected_C1 = [
        [-9,  5,  2,  5],
        [10, -3, -3, -7],
        [ 8,  7, -7, -5],
        [-3, -2,  4, -1]
    ]
    run_test_case(A1, B1, "TEST CASE 1: A1 x B1", Expected_C1, USE_APPROX)

   # --- TEST CASE 2: I x B2 = B2 ---
    A2 = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]
    
  
    B2 = [
        [ 1,  0,  0,  0],
        [-2,  2, -1,  1],
        [ 1,  1,  1, -1],
        [ 0,  0, -2,  2]
    ]
    run_test_case(A2, B2, "TEST CASE 2: A2(I) x B2 = B2", B2, USE_APPROX)

    # --- TEST CASE 3: A3 x I = A3 ---
    A3 = [[2, -1, 1, 0], [1, 2, -2, 1], [-1, 0, 2, -2], [0, 1, -1, 2]]
    B3 = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]
    run_test_case(A3, B3, "TEST CASE 3: A3 x B3(I) = A3", A3, USE_APPROX)
