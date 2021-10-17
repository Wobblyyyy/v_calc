import cli { Command }
import os
import strconv
import math

const (
	desc_cmd        = 'Simple command line parser and calculator.\n' +
		'Supports simple equation parsing.\n' +
		'Parantheses are not support - use brackets ("[" and "]") instead.\n' +
		'Function calls (such as "sin", "sqrt", or "cbrt" use curly braces (ex: "sqrt{2}"\n' +
		'Valid operators are as follows:\n' + '- addition:       +\n' + '- subtraction:    -\n' +
		'- multiplication: *\n' + '- division:       /\n' + '- exponent:       ^\n' +
		'- root:           #'
	desc_cmd_c      = 'Shorter alias for "calc".'
	desc_cmd_calc   = 'Parse an expression and calculate its output.'
	desc_cmd_vc     = 'Shorter alias for "vcalc".'
	desc_cmd_vcalc  = 'Same as "calc", but with more debugging and logging.'
	desc_cmd_avg    = 'Average a set of comma-delimited expressions or numbers.'
	desc_cmd_hypot  = 'Calculate the hypotenuse of two legs.'
	desc_cmd_vhypot = 'Same as "hypot", but with more debugging and logging.'
	desc_cmd_add    = 'Add two numbers together.'
	desc_cmd_vadd   = 'Same as "add", but with more debugging and logging.'
	math_pi         = 3.14159265359
)

fn main() {
	mut cmd := Command{
		name: 'clicalc'
		description: desc_cmd
		version: '1.0.0'
	}
	mut cmd_c := Command{
		name: 'c'
		description: desc_cmd_c
		usage: '<name> expression'
		required_args: 1
		execute: cmd_calc_fn
	}
	mut cmd_calc := Command{
		name: 'calc'
		description: desc_cmd_calc
		usage: '<name> expression'
		required_args: 1
		execute: cmd_calc_fn
	}
	mut cmd_vcalc := Command{
		name: 'vcalc'
		description: desc_cmd_vcalc
		usage: '<name> expression'
		required_args: 1
		execute: cmd_vcalc_fn
	}
	mut cmd_vc := Command{
		name: 'vc'
		description: desc_cmd_vc
		usage: '<name> expression'
		required_args: 1
		execute: cmd_vcalc_fn
	}
	mut cmd_avg := Command{
		name: 'avg'
		description: desc_cmd_avg
		usage: '<name> num1,num2,num3...'
		required_args: 1
		execute: cmd_avg_nums
	}
	mut cmd_hypot := Command{
		name: 'hypot'
		description: desc_cmd_hypot
		usage: '<name> a b'
		required_args: 2
		execute: cmd_hypot_fn
	}
	mut cmd_vhypot := Command{
		name: 'vhypot'
		description: desc_cmd_vhypot
		usage: '<name> a b'
		required_args: 2
		execute: cmd_vhypot_fn
	}
	mut cmd_add := Command{
		name: 'add'
		description: desc_cmd_add
		usage: '<name> a b'
		required_args: 2
		execute: cmd_add_fn
	}
	mut cmd_vadd := Command{
		name: 'vadd'
		description: desc_cmd_vadd
		usage: '<name> a b'
		required_args: 2
		execute: cmd_vadd_fn
	}

	cmd.add_command(cmd_c)
	cmd.add_command(cmd_calc)
	cmd.add_command(cmd_vc)
	cmd.add_command(cmd_vcalc)
	cmd.add_command(cmd_avg)
	cmd.add_command(cmd_hypot)
	cmd.add_command(cmd_vhypot)
	cmd.add_command(cmd_add)
	cmd.add_command(cmd_vadd)

	cmd.setup()
	cmd.parse(os.args)
}

fn cmd_avg_nums(cmd Command) {
	unparsed_nums := cmd.args[0].split(',').filter(it.len > 0)
	println(unparsed_nums)
	mut cmd_str := '['
	for i := 0; i < unparsed_nums.len; i++ {
		num := unparsed_nums[i]
		if i != unparsed_nums.len - 1 {
			cmd_str += '$num+'
		} else {
			cmd_str += num
		}
	}
	cmd_str += ']/$unparsed_nums.len='
	parse_expr(cmd_str, false, 0)
}

fn calc_expr(a f64, b f64, op Operator, debug bool, nest_lvl int) f64 {
	if debug {
		debug_log('exprcalc', 'performing $op.str() on $a and $b', nest_lvl)
	}
	match op {
		.plus {
			return a + b
		}
		.minus {
			return a - b
		}
		.multiply {
			return a * b
		}
		.divide {
			if b == 0 {
				println('divide by zero error (attempted to divide $a by 0)')
				return 0
			}
			return a / b
		}
		.pow {
			return math.pow(a, b)
		}
		.root {
			return math.pow(a, 1.0 / b)
		}
	}
}

fn perform_func(a f64, func Func, debug bool, nest_lvl int) f64 {
	if debug {
		debug_log('exprfunc', 'performing function "$func.str()" on $a', nest_lvl)
	}
	match func {
		.sin {
			return math.sin(a)
		}
		.cos {
			return math.cos(a)
		}
		.tan {
			return math.tan(a)
		}
		.sqrt {
			return math.pow(a, 0.5)
		}
		.cbrt {
			return math.pow(a, 1.0 / 3.0)
		}
	}
}

fn syntax_check(chars []string, open string, close string) bool {
	mut t_open := 0
	mut t_close := 0
	mut i := 0
	for ; i < chars.len; i++ {
		char := chars[i]
		if char == open {
			t_open += 1
		} else if char == close {
			t_close += 1
		}
	}
	if t_open != t_close {
		println('ERROR: mismatched brackets! OPEN and CLOSE type must be the same!')
		println('       bracket type: $open$close')
		println('       open  ("$open") count: $t_open')
		println('       close ("$close") count: $t_close')
		idx_min := if i - 4 > 0 { i - 4 } else { 0 }
		idx_max := if i + 4 < chars.len { i + 4 } else { chars.len - 1 }
		mut up := ''
		mut bl := ''
		if idx_min != 0 {
			up += '...'
			bl += '   '
		}
		if t_open - t_close == 1 {
			bl += ' '
		}
		for j := idx_min; j <= idx_max; j++ {
			up += chars[j]
			if j == i || j == chars.len - 1 {
				bl += '^ here (char #${i + 1} of $chars.len)'
			} else {
				bl += ' '
			}
		}
		if idx_max != chars.len - 1 {
			up += '...'
		}
		if t_open - t_close == 1 {
			bl += ' (missing end bracket)'
		}
		println('')
		println('       your syntax error was right around...')
		println('       $up')
		println('       $bl')
		return false
	}
	return true
}

fn parse_expr(oi string, debug bool, nest_lvl int) f64 {
	mut input := oi
	mut reduction_count := 0
	for input.contains('[]') {
		input = input.replace('[]', '')
		reduction_count += 1
	}
	for input.contains('][') {
		input = input.replace('][', ']*[')
		if debug {
			debug_log('autocorrect', 'automatically inserted "]*[" in place of "]["',
				nest_lvl)
		}
	}
	for input.contains('}[') {
		input = input.replace('}[', '}*[')
		if debug {
			debug_log('autocorrect', 'automatically inserted "}*[" in place of "}["',
				nest_lvl)
		}
	}
	for i in 0 .. 9 {
		for input.contains('$i[') {
			input = input.replace('$i[', '$i*[')
			if debug {
				debug_log('autocorrect', 'automatically inserted "$i*[" in place of "$i["',
					nest_lvl)
			}
		}
		for input.contains(']$i') {
			input = input.replace(']$i', ']*$i')
			if debug {
				debug_log('autocorrect', 'automatically inserted "]*$i" in place of "]$i"',
					nest_lvl)
			}
		}
	}
	for input.contains('PI') || input.contains('pi') {
		input = input.replace('PI', math_pi.str()).replace('pi', math_pi.str())
		if debug {
			debug_log('autocorrect', 'automatically replaced "PI" with $math_pi.str()',
				nest_lvl)
		}
	}
	if reduction_count > 0 {
		println('WARN: empty bracket pairs found!')
		println('      empty bracket pair count: $reduction_count pair(s)')
		println('      performed bracket reduction')
		println('      original input length:  $oi.len')
		println('      optimized input length: $input.len')
	}
	if debug {
		debug_log('parse', 'parsing expression "$input"', nest_lvl)
	}
	if input.len == 0 {
		return 0
	} else if input.contains('{}') {
		println('ERROR: cannot parse empty function!')
		println('       example valid function call:   "sin{3}"')
		println('       example invalid function call: "sin{}"')
		println('       make sure all curly brace pairs contain a valid expression!')
		return 0
	}
	mut chars := input.split('')
	mut was_last_curly := false
	mut needs_to_redo_chars := false
	mut t_open_bracket := 0
	mut t_close_bracket := 0
	mut t_open_curly := 0
	mut t_close_curly := 0
	for i := 0; i < chars.len; i++ {
		char := chars[i]
		match char {
			'[' {
				t_open_bracket++
				was_last_curly = false
			}
			']' {
				t_close_bracket++
				was_last_curly = false
			}
			'{' {
				t_open_curly++
				was_last_curly = true
			}
			'}' {
				t_close_curly++
				was_last_curly = true
			}
			else {}
		}
	}
	if debug {
		debug_log('charcount', '"[" count: $t_open_bracket', nest_lvl)
		debug_log('charcount', '"]" count: $t_close_bracket', nest_lvl)
		debug_log('charcount', '"{" count: $t_open_curly', nest_lvl)
		debug_log('charcount', '"}" count: $t_close_curly', nest_lvl)
	}
	if t_open_bracket != t_close_bracket {
		if was_last_curly {
			input += '}'
		} else {
			input += ']'
		}
		needs_to_redo_chars = true
	}
	if t_open_curly != t_close_curly {
		if was_last_curly {
			input += '}'
		} else {
			input += ']'
		}
		needs_to_redo_chars = true
	}
	if needs_to_redo_chars {
		chars = input.split('')
		last_added_char := if was_last_curly { '}' } else { ']' }
		if debug {
			debug_log('autocorrect', 'automatically inserted "$last_added_char"', nest_lvl)
		}
	}
	valid_brackets := syntax_check(chars, '[', ']')
	valid_curly := syntax_check(chars, '{', '}')
	if !valid_brackets || !valid_curly {
		if !valid_brackets && !valid_curly {
			println('ERROR: multiple types of mismatched braces/brackets!')
			println('       there was an error processing both types of brackets - {} and []')
			println('')
			println('       square brackets ("[]"):')
			println('       - open  ("[") count: $t_open_bracket')
			println('       - close ("]") count: $t_close_bracket')
			println('')
			println('       curly braces ("{}"):')
			println('       - open  ("{") count: $t_open_curly')
			println('       - close ("}") count: $t_close_curly')
		}
	}
	mut unparsed_num := ''
	mut parsed_nums := []f64{}
	mut operators := []Operator{}
	mut can_add_num := true
	mut curr_op := ''
	if chars[chars.len - 1].str() != '=' {
		chars << '='
	}
	for i := 0; true; i++ {
		if i >= chars.len {
			break
		}
		char := chars[i]
		match char {
			'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.' {
				unparsed_num += char
			}
			'%' {
				unparsed_num += '-'
			}
			'[' {
				mut unparsed_expr_str := ''
				if debug {
					debug_log('parse', 'parsing bracket pair at index $i', nest_lvl)
				}
				if i + 1 != input.len {
					mut ctr := 0
					mut curly_ctr := 0
					for j := i + 1; j < input.len; j++ {
						curr_char := chars[j]
						if curr_char == '{' {
							curly_ctr += 1
						} else if curr_char == '}' {
							if curly_ctr == 0 {
								println('ERROR: unexpected character "{"')
								println('       there was an unexpected character while processing:')
								println('       expecting: "]"')
								println('       input: "$input"')
								println('       current expression: "$unparsed_expr_str"')
								return 0
							}
							curly_ctr -= 1
						}
						if curr_char == '[' {
							ctr += 1
							unparsed_expr_str += curr_char
						} else if curr_char == ']' {
							if ctr == 0 {
								break
							} else {
								unparsed_expr_str += curr_char
								ctr -= 1
							}
						} else {
							unparsed_expr_str += curr_char
						}
					}
					val := parse_expr(unparsed_expr_str, debug, nest_lvl + 1)
					mut val_str := val.str()
					if val_str.split('')[val_str.len - 1] == '.' {
						val_str = val_str.replace('.', '')
						parsed_nums << strconv.atoi(val_str) or { 0 }
					} else {
						parsed_nums << strconv.atof_quick(val_str)
					}
					chars.clear()
					if debug {
						debug_log('parse', 'finished bracket parse with result "$val_str"',
							nest_lvl)
					}
					input = input.replace('[$unparsed_expr_str]', val_str)
					chars << input.replace('[$unparsed_expr_str]', val_str).split('')
					if val_str.len > 1 {
						i += val_str.len - 1
					}
				}
			}
			']' {}
			'+', '-', '*', '/', '^', '=', '#' {
				if unparsed_num.len > 0 {
					if can_add_num {
						parsed_nums << strconv.atof_quick(unparsed_num.replace('%', '-'))
						unparsed_num = ''
					} else {
						can_add_num = true
					}
				}
				match char {
					'+' { operators << Operator.plus }
					'-' { operators << Operator.minus }
					'*' { operators << Operator.multiply }
					'/' { operators << Operator.divide }
					'^' { operators << Operator.pow }
					'#' { operators << Operator.root }
					else {}
				}
			}
			'{' {
				mut unparsed := ''
				mut ctr := 0
				mut square_ctr := 0
				if debug {
					debug_log('parse', 'parsing curly brace pair at index $i', nest_lvl)
				}
				if i + 1 != input.len {
					for j := i + 1; j < input.len; j++ {
						curr_char := chars[j]
						if curr_char == '[' {
							square_ctr += 1
						} else if curr_char == ']' {
							if square_ctr == 0 {
								println('ERROR: unexpected character "]"')
								println('       there was an unexpected character while processing:')
								println('       expecting: "}"')
								println('       input: "$input"')
								println('       current expression: "$unparsed"')
								return 0
							}
							square_ctr -= 1
						}
						if curr_char == '{' {
							ctr += 1
						}
						if curr_char != '}' {
							unparsed += curr_char
						} else {
							if ctr == 0 {
								break
							} else {
								unparsed += '}'
							}
							ctr -= 1
						}
					}
					mut val := parse_expr(unparsed, debug, nest_lvl + 1)
					to_remove := '$curr_op' + '{' + unparsed + '}'
					match curr_op {
						'sin' {
							val = perform_func(val, Func.sin, debug, nest_lvl)
						}
						'cos' {
							val = perform_func(val, Func.cos, debug, nest_lvl)
						}
						'tan' {
							val = perform_func(val, Func.tan, debug, nest_lvl)
						}
						'sqrt' {
							val = perform_func(val, Func.sqrt, debug, nest_lvl)
						}
						'cbrt' {
							val = perform_func(val, Func.cbrt, debug, nest_lvl)
						}
						else {
							println('ERROR: invalid function!')
							println('       function name:   "$curr_op"')
							println('       parsed input:     $val')
							println('       unparsed input:   $unparsed')
						}
					}
					mut val_str := val.str().replace('-', '%')
					chars.clear()
					if val_str.split('')[val_str.len - 1] == '.' {
						val_str = val_str.replace('.', '')
					}
					if val_str.len > 1 {
						i += val_str.len - (curr_op.len + 1)
					}
					input = input.replace(to_remove, val_str)
					chars << input.split('')
					curr_op = ''
					unparsed_num = val_str
					if debug {
						debug_log('parse', 'finished curly parse with result "$val_str"',
							nest_lvl)
					}
				}
			}
			else {
				curr_op += char
			}
		}
	}
	if unparsed_num.len > 0 {
		parsed_nums << strconv.atof_quick(unparsed_num.replace('%', '-'))
		unparsed_num = ''
	}
	if parsed_nums.len == 1 {
		return parsed_nums[0]
	}
	if parsed_nums.len == 0 || operators.len == 0 {
		println('ERROR: invalid expression!')
		println('       input expression:  "$input"')
		println('       PARAMS: numbers:   $parsed_nums.str()')
		println('       PARAMS: operators: $operators.str()')
		println('       please ensure you provide at least...')
		println('       - 1 number')
		println('       - 1 operator')
		println('       valid example:     "3+3="')
		println('       invalid example 1: "3"')
		println('       invalid example 2: "="')
		return 0
	}
	for parsed_nums.len > 1 {
		if operators.len != parsed_nums.len - 1 {
			println('ERROR: invalid operator count')
			println('       numbers count:   $parsed_nums.len')
			println('       operators count: $operators.len')
			println('')
			println('       dumping numbers')
			for i := 0; i < parsed_nums.len; i++ {
				println('       - ($i) ${parsed_nums[i]}')
			}
			println('')
			println('       dumping operators')
			for i := 0; i < operators.len; i++ {
				println('       - ($i) ${operators[i]}')
			}
			break
		}
		a := parsed_nums[0]
		b := parsed_nums[1]
		op := operators[0]
		result := calc_expr(a, b, op, debug, nest_lvl)
		parsed_nums.delete_many(0, 2)
		operators.delete(0)
		parsed_nums.insert(0, result)
	}
	if debug {
		debug_log('parse', 'finished parsing expr $input', nest_lvl)
		debug_log('parse', 'result: ${parsed_nums[0].str()}', nest_lvl)
	}
	return parsed_nums[0]
}

fn cmd_calc_fn(cmd Command) {
	val := parse_expr(cmd.args[0], false, 0)
	println('RESULT: $val')
}

fn cmd_vcalc_fn(cmd Command) {
	val := parse_expr(cmd.args[0], true, 0)
	println('RESULT: $val')
}

fn cmd_hypot_fn(cmd Command) {
	a := cmd.args[0]
	b := cmd.args[1]
	val := parse_expr('sqrt{[$a^2]+[$b^2]}', false, 0)
	println('RESULT: $val')
}

fn cmd_vhypot_fn(cmd Command) {
	a := cmd.args[0]
	b := cmd.args[1]
	val := parse_expr('sqrt{[$a^2]+[$b^2]}', true, 0)
	println('RESULT: $val')
}

fn cmd_add_fn(cmd Command) {
	a := cmd.args[0]
	b := cmd.args[1]
	val := parse_expr('[$a]+[$b]', false, 0)
	println('RESULT: $val')
}

fn cmd_vadd_fn(cmd Command) {
	a := cmd.args[0]
	b := cmd.args[1]
	val := parse_expr('[$a]+[$b]', true, 0)
	println('RESULT: $val')
}

fn debug_log(prefix string, message string, nest_lvl int) {
	if nest_lvl > 0 {
		mut nest_prefix := if nest_lvl <= 9 { '0$nest_lvl' } else { nest_lvl.str() }
		for i := nest_lvl; i != 0; i-- {
			nest_prefix += '--'
		}
		println('$nest_prefix$prefix: $message')
	} else {
		println('$prefix: $message')
	}
}

enum Operator {
	plus
	minus
	multiply
	divide
	pow
	root
}

enum Func {
	sin
	cos
	tan
	sqrt
	cbrt
}
