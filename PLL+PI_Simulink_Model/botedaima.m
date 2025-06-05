% 相位裕度55°参数验证
clear; close all; clc;

% 1. 设置系统参数 (基于相位裕度55°设计)
KN = 0.7853;           % 开环增益
xi_prime = 0.7;         % 阻尼比
wy = 10;                % 自然频率 (rad/s)
k2 = 0.03153;           % 时间常数1 (s)
k3 = 0.03153;           % 时间常数2 (s)

% 2. 构建传递函数
% 分子多项式: s² + 2ξ′ωy·s + ωy²
num = [1, 2*xi_prime*wy, wy^2];

% 分母多项式: s²·(k₂s + 1)·(k₃s + 1) = k₂k₃s⁴ + (k₂+k₃)s³ + s²
den = conv([1, 0, 0], conv([k2, 1], [k3, 1]));  % 使用卷积展开多项式

% 创建传递函数 (包含增益KN)
G2 = tf(KN*num, den);

% 3. 在ω=10 rad/s处验证频率响应
w_gc = 10;  % 设计增益穿越频率
[mag, phase_deg] = bode(G2, w_gc);
mag_linear = squeeze(mag);
phase_deg = squeeze(phase_deg);

% 4. 计算相位裕度
[Gm, Pm, Wcg, Wcp] = margin(G2);

% 5. 显示验证结果
fprintf('==== 验证结果 (设计目标: 相位裕度55° @ ω=10 rad/s) ====\n');
fprintf('在 ω = %.2f rad/s 处:\n', w_gc);
fprintf('  增益 = %.4f (线性) ≈ 1.0\n', mag_linear);
fprintf('  相位 = %.2f°\n', phase_deg);
fprintf('  相位裕度 = %.2f° (计算值)\n\n', Pm);
fprintf('理论相位裕度: PM = %.0f° + 180° = %.0f°\n', phase_deg, phase_deg + 180);
fprintf('实际计算相位裕度: %.2f° (接近设计值55°)\n\n', Pm);

fprintf('增益穿越频率: %.4f rad/s (接近设计值10 rad/s)\n', Wcp);

% 6. 绘制伯德图
figure;
margin(G2); 
grid on;
title(sprintf('系统伯德图 \\rightarrow 相位裕度: %.2f° @ %.3f rad/s', Pm, Wcp));


% 8. 在命令行显示传递函数
disp('传递函数模型:');
G2