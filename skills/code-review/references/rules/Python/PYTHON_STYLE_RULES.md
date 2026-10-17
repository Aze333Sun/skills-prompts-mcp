# Python 代码风格扫描规则（共8条）

---

## 一、格式规则（4项）

### 1. PY023 LineLength - 每行不得超过120个字符 [Critical]

**缺陷描述**：单行字符数不超过 120 个字符，超出需要换行。

---

### 2. PY030 Whitespace - 逗号、分号、冒号前不加空格，后边加一个空格 [Critical]

**缺陷描述**：逗号（`,`）、分号（`;`）、冒号（`:`）前不加空格，其后需加一个空格。

**经典案例**：
```python
# 错误写法
x = [1 , 2 , 3]
d = {"key" : "value"}
x = [1,2,3]

# 正确写法
x = [1, 2, 3]
d = {"key": "value"}
```

**豁免场景**：切片中的冒号（`x[1:2]`）；字符串字面量内部；类型注解中的冒号。

---

### 3. PY031 WhitespaceAroundOperator - 所有二元运算符前后各加一个空格 [Critical]

**缺陷描述**：所有二元运算符（赋值、算术、比较、逻辑、位运算、类型注解箭头 `->` 等）前后均需各加一个空格。

**经典案例**：
```python
# 错误写法
x=1
if x>0 and y<10:
    pass
def get_name()->str:
    return self.name

# 正确写法
x = 1
if x > 0 and y < 10:
    pass
def get_name() -> str:
    return self.name
```

**豁免场景**：关键字参数或默认值中的等号（见 PY032）；一元运算符；切片中的冒号。

---

### 4. PY032 WhitespaceAroundNamedParameterEquals - 关键字参数或参数默认值里的等号前后不加空格 [Critical]

**缺陷描述**：函数定义中的默认参数值和函数调用中的关键字参数，其等号（`=`）前后不应加空格。

**经典案例**：
```python
# 错误写法
def func(x = 1, y = 2):
    pass
result = func(x = 10, y = 20)

# 正确写法
def func(x=1, y=2):
    pass
result = func(x=10, y=20)
```

**豁免场景**：带类型注解的默认参数（`def func(x: int = 1)` 中等号前后需加空格）。

---

## 二、文档规则（2项）

### 5. PY033 Docstring - 使用docstring描述module、function、class和method接口 [Critical]

**缺陷描述**：module、function、class 和 method 的接口必须使用 docstring 进行描述，格式为三个双引号（`"""`），不得使用单引号（`'''`）或 `//` 注释替代。

**扫描要求**：
1. **优先命令行预扫描**：使用 awk 扫描所有 `def`/`class` 定义，检查下一非空行是否以 `"""` 开头，直接产出缺失列表
2. **PY033 与 PY034 分离**：
   - 完全无 docstring → 报 PY033
   - 有 docstring 但缺 Args/Returns → 报 PY034
   - 同一函数不得同时报两条，按"无 docstring 优先"处理
3. **覆盖确认**：规则覆盖确认表中注明命令行预扫描结果，无需手动穷举

**重要说明**：
- **method 必须独立检查**：类中每个方法都须有独立 docstring，类有 docstring 不豁免方法

**经典案例**：
```python
# 错误写法 — 函数缺少docstring
def calculate_total(price, quantity, discount):
    return price * quantity * (1 - discount)

# 错误写法 — 使用单引号
def get_user(user_id):
    '''根据ID获取用户信息。'''
    return db.query(user_id)

# 正确写法
def calculate_total(price, quantity, discount):
    """计算商品总价。"""
    return price * quantity * (1 - discount)
```

**豁免场景**：`__init__`（类已有 docstring 时）；`__str__`、`__repr__`、`__eq__`、`__hash__` 等魔术方法；一行体的简单 property；**私有辅助方法（`_` 前缀）**；**逻辑简单、函数体不超过 5 行的内部函数**。

---

### 6. PY034 DocstringContent - 接口docstring描述至少包括功能简介、参数、返回值 [Critical]

**缺陷描述**：**对外暴露的公开函数/方法**（无 `_` 前缀，且参数多于 2 个或有明确返回值），其 docstring 建议包含功能简介、参数（Args）、返回值（Returns）。**仅报告完全缺少描述、或参数说明严重缺失（多参数函数一个 Args 也没有）的情况**，不对格式细节（如类型注解是否完整、描述措辞）作要求。

**标准 docstring 格式参考**（Google 风格，不强制）：
```
"""功能简介。

Args:
    参数名: 参数描述。

Returns:
    返回值描述。
"""
```

**经典案例**：
```python
# 报告 — 有多个参数但 docstring 完全没有参数说明
def get_user_by_id(user_id, include_deleted):
    """获取用户信息。"""   # 缺 Args
    ...

# 不报告 — 简单单参数函数，只有功能简介可接受
def get_user_by_id(user_id):
    """根据用户ID查询用户信息。"""
    ...
```

**豁免场景**：
- 无参数或只有 1 个参数的简单函数（只需功能简介）
- `__init__` 方法
- 私有方法（`_` 前缀）
- 函数体不超过 5 行的内部/辅助函数
- 参数含类型注解且语义自明的函数（如 `def add(a: int, b: int) -> int`）

---

## 三、编程实践规则（2项）

### 7. PY018 CompareToNone - 禁止使用==或!=判断表达式是否为None [Critical]

**缺陷描述**：判断对象是否为 `None` 时，禁止使用 `==` 或 `!=`，应使用 `is` 或 `is not`。

**经典案例**：
```python
# 错误写法
if result == None:
    return
if user != None and user.is_active:
    grant_access(user)

# 正确写法
if result is None:
    return
if user is not None and user.is_active:
    grant_access(user)
```

---

## 四、命名规则（1项）

### 8. PY039 ClassName - 类（包括异常）名使用首字母大写驼峰式命名 [Critical]

**缺陷描述**：类名必须使用首字母大写的驼峰式命名（PascalCase），匹配正则 `^[A-Z][a-zA-Z0-9]*$`。

**经典案例**：
```python
# 错误写法
class userService: pass
class user_service: pass
class invalidInputError(Exception): pass

# 正确写法
class UserService: pass
class InvalidInputError(Exception): pass
```

**核心原则：只报告能明确看到 `class` 关键字后的类名不符合大驼峰规范的情况。动态类创建等场景不报告。**
