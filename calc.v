import cli { Command }
import os
import strconv
import math

const (
	desc_cmd        = 'Simple command line parser and calculator.\n' +
		'Supports simple equation parsing.\n' +
		'Parantheses are not support - use brackets ("[" and "]") instead.\n' +
		'Function calls (such as "sin", "sqrt", or "cbrt" use curly braces (ex: "sqrt{2}")\n' +
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
	desc_cmd_var    = 'Substitute values into an equation.'
	desc_cmd_vvar   = 'Same as "var", but with more debugging and logging.'
	desc_cmd_mvar   = 'Substitute multiple values into an equation with multiple variables.'
	desc_cmd_vmvar  = 'Same as "mvar", but with more debugging and logging.'
	desc_cmd_rsin   = "Sine in radians mode."
	desc_cmd_dsin   = "Sine in degrees mode."
	desc_cmd_rcos   = "Cosine in radians mode."
	desc_cmd_dcos   = "Cosine in degrees mode."
	desc_cmd_rtan   = "Tangent in radians mode."
	desc_cmd_dtan   = "Tangent in degrees mode."
	math_pi         = 3.14159265359
	math_rt_2       = 1.41421356237
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
	mut cmd_var := Command{
		name: 'var'
		description: desc_cmd_var
		usage: '<name> equation var_name:var_value_1,var_value_2'
		required_args: 2
		execute: cmd_var_fn
	}
	mut cmd_vvar := Command{
		name: 'vvar'
		description: desc_cmd_vvar
		usage: '<name> equation var_name:var_value_1,var_value_2'
		required_args: 2
		execute: cmd_vvar_fn
	}
	mut cmd_mvar := Command{
		name: 'mvar'
		description: desc_cmd_mvar 
		usage: '<name> equation var_name_1:var_value_1,var_value_2 var_name_2:var_value_1'
		required_args: 3
		execute: cmd_mvar_fn
	}
	mut cmd_vmvar := Command{
		name: 'vmvar'
		description: desc_cmd_vmvar 
		usage: '<name> equation var_name_1:var_value_1,var_value_2 var_name_2:var_value_1'
		required_args: 3
		execute: cmd_vmvar_fn
	}
	mut cmd_rsin := Command{
		name: 'rsin'
		description: desc_cmd_rsin
		usage: '<name> value'
		required_args: 1
		execute: cmd_rsin_fn
	}
	mut cmd_dsin := Command{
		name: 'dsin'
		description: desc_cmd_dsin
		usage: '<name> value'
		required_args: 1
		execute: cmd_dsin_fn
	}
	mut cmd_rcos := Command{
		name: 'rcos'
		description: desc_cmd_rcos
		usage: '<name> value'
		required_args: 1
		execute: cmd_rcos_fn
	}
	mut cmd_dcos := Command{
		name: 'dcos'
		description: desc_cmd_dcos
		usage: '<name> value'
		required_args: 1
		execute: cmd_dcos_fn
	}
	mut cmd_rtan := Command{
		name: 'rtan'
		description: desc_cmd_rtan
		usage: '<name> value'
		required_args: 1
		execute: cmd_rtan_fn
	}
	mut cmd_dtan := Command{
		name: 'dtan'
		description: desc_cmd_dtan
		usage: '<name> value'
		required_args: 1
		execute: cmd_dtan_fn
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
	cmd.add_command(cmd_var)
	cmd.add_command(cmd_vvar)
	cmd.add_command(cmd_mvar)
	cmd.add_command(cmd_vmvar)
	cmd.add_command(cmd_rsin)
	cmd.add_command(cmd_dsin)
	cmd.add_command(cmd_rcos)
	cmd.add_command(cmd_dcos)
	cmd.add_command(cmd_rtan)
	cmd.add_command(cmd_dtan)

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
		.deg {
			return a * (180 / math_pi)
		}
		.rad {
			return a * (math_pi / 180)
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
		println('ERROR: mismatched brackets! OPEN and CLOSE count must be the same!')
		println('       bracket type: $open$close')
		println('       open  ("$open") count: $t_open')
		println('       close ("$close") count: $t_close')
		idx_min := if i - 8 > 0 { i - 8 } else { 0 }
		idx_max := if i + 8 < chars.len { i + 8 } else { chars.len - 1 }
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
		if t_open - t_close >= 1 {
			bl += ' (missing end bracket)'
		}
		println('')
		println('       your syntax error was right around...')
		println('       $up')
		println('       $bl')
		println('')
		println('       tips to fix this issue:')
		println('       - make sure every "[" has a corresponding "]"')
		println('       - make sure every "{" has a corresponding "}"')
		println('       - make sure "[]" and "{}" pairs are logically written')
		exit(1)
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
		debug_log('autocorrect', 'automatically inserted "]*[" in place of "]["',
			nest_lvl)
	}
	for input.contains('}[') {
		input = input.replace('}[', '}*[')
		debug_log('autocorrect', 'automatically inserted "}*[" in place of "}["',
			nest_lvl)
	}
	for i in 0 .. 9 {
		for input.contains('$i[') {
			input = input.replace('$i[', '$i*[')
			debug_log('autocorrect', 'automatically inserted "$i*[" in place of "$i["',
				nest_lvl)
		}
		for input.contains(']$i') {
			input = input.replace(']$i', ']*$i')
			debug_log('autocorrect', 'automatically inserted "]*$i" in place of "]$i"',
				nest_lvl)
		}
	}
	for input.contains('PI') || input.contains('pi') {
		input = input.replace('PI', math_pi.str()).replace('pi', math_pi.str())
		debug_log('autocorrect', 'automatically replaced "PI" with $math_pi.str()',
			nest_lvl)
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
		exit(1)
		return 0
	}
	mut chars := input.split('')
	t_open_bracket := chars.filter(it == '[').len
	t_close_bracket := chars.filter(it == ']').len
	t_open_curly := chars.filter(it == '{').len
	t_close_curly := chars.filter(it == '}').len
	if debug {
		if !(t_open_bracket == 0 && t_close_bracket == 0) {
			debug_log('charcount', '"[" count: $t_open_bracket', nest_lvl)
			debug_log('charcount', '"]" count: $t_close_bracket', nest_lvl)
		}
		if !(t_open_curly == 0 && t_close_curly == 0) {
			debug_log('charcount', '"{" count: $t_open_curly', nest_lvl)
			debug_log('charcount', '"}" count: $t_close_curly', nest_lvl)
		}
	}
	valid_brackets := syntax_check(chars, '[', ']')
	valid_curly := syntax_check(chars, '{', '}')
	if !valid_brackets || !valid_curly {
		if !valid_brackets && !valid_curly {
			println('ERROR: multiple types of mismatched braces/brackets!')
			println('       there was an error processing both types of brackets - {} and []')
			println('')
			println('       an error occured while processing the following input:')
			println('       "$input"')
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
								exit(1)
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
								exit(1)
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
						'to_deg', 'rad_to_deg' {
							val = perform_func(val, Func.deg, debug, nest_lvl)
						}
						'to_rad', 'deg_to_rad' {
							val = perform_func(val, Func.rad, debug, nest_lvl)
						}
						else {
							println('ERROR: invalid function!')
							println('       function name:   "$curr_op"')
							println('       parsed input:     $val')
							println('       unparsed input:   $unparsed')
							exit(1)
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
		println('ERROR: expression could not be parsed because of missing numbers or operators.')
		println('       input expression:')
		println('       "$input"')
		println('')
		println('       PARAMS: numbers:   $parsed_nums.str()')
		println('       PARAMS: operators: $operators.str()')
		println('')
		println('       please ensure you provide at least...')
		println('       - 1 number')
		println('       - 1 operator')
		println('')
		println('       valid example:   "3+3="')
		println('       invalid example: "3"')
		println('       invalid example: "="')
		println('')
		println('       you might be attempting to parse a bit of text, such as:')
		println('       - "y"')
		println('       - "abc"')
		println('       if that is the case, make sure you are parsing numbers!')
		exit(1)
	}
	for parsed_nums.len > 1 {
		if operators.len != parsed_nums.len - 1 {
			println('ERROR: invalid # of operators (either too few or too many)')
			println('       numbers count:   $parsed_nums.len')
			println('       operators count: $operators.len')
			if operators.len >= parsed_nums.len {
				println('')
				println('       too many operators!')
				println('       expected: ${parsed_nums.len - 1}')
				println('       found:    $operators.len')
			}
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
			exit(1)
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

fn split_data(data string) (string, []string) {
	split_data := data.split(':')
	name := split_data[0]
	mut vals := split_data[1].split(',')
	for i := 0; i < vals.len; i++ {
		val := vals[i]
		mut go_down := false
		if val.contains('...') {
			go_down = true
			vals.delete(i)
			split_val := val.split('...')
			min := strconv.atoi(split_val[0]) or { 0 }
			max := strconv.atoi(split_val[1]) or { 0 }
			for j := min; j <= max; j++ {
				vals.insert(i, j.str())
				i++
			}
		} else if val.contains('..') {
			go_down = true
			vals.delete(i)
			split_val := val.split('..')
			min := strconv.atoi(split_val[0]) or { 0 }
			max := strconv.atoi(split_val[1]) or { 0 }
			for j := min; j < max; j++ {
				vals.insert(i, j.str())
				i++
			}
		}
		if go_down {
			i--
		}
	}
	return name, vals
}

fn var_fn(cmd Command, debug bool) {
	unparsed_equation := cmd.args[0]

	for i := 1; i < cmd.args.len; i++ {
		var_name, mut var_values := split_data(cmd.args[i])

		println('check: verifying equation syntax...')
		parse_expr(unparsed_equation.replace(var_name, math_rt_2.str()), debug, 0)
		println('check: successfully verified equation syntax')
		println('')

		println('check: verifying values for variable "$var_name"...')
		for j := 0; j < var_values.len; j++ {
			parse_expr(var_values[j], debug, 0)
		}
		println('check: successfully verified all $var_values.len values for variable "$var_name"')
		println('')

		if !unparsed_equation.contains(var_name) {
			println('ERROR: attempted to use an invalid variable')
			println('       attempted to use...')
			println('         var name: $var_name')
			println('         var vals: $var_values.str()')
			println('       input expression: $unparsed_equation')
			println('       make sure you are using the correct variable name!')
			exit(1)
			return
		}

		var_values.insert(0, '"$var_name"')

		mut max_len := f64(var_name.len) + 2.0
		for j := 0; j < var_values.len; j++ {
			value := var_values[j]
			max_len = math.max(max_len, value.len)
		}

		mut formatted_values := []string{}
		for j := 0; j < var_values.len; j++ {
			mut formatted_value := var_values[j]
			size_diff := max_len - formatted_value.len
			for k := 0; k < size_diff; k++ {
				formatted_value += ' '
			}
			formatted_values << formatted_value
		}

		for j := 0; j < var_values.len; j++ {
			val := if j != 0 { parse_expr(var_values[j], debug, 0) } else { 0.0 }
			mut equ_with_val := unparsed_equation

			if j != 0 {
				for equ_with_val.contains(var_name) {
					equ_with_val = equ_with_val.replace(var_name, val.str())
				}
			}

			result := if j == 0 { 'OUTPUT' } else { parse_expr(equ_with_val, debug, 0).str() }

			println('${formatted_values[j]}  |  $result')
		}
	}
}

fn cmd_var_fn(cmd Command) {
	var_fn(cmd, false)
}

fn cmd_vvar_fn(cmd Command) {
	var_fn(cmd, true)
}

fn validate_var(unparsed_equation string, var_name string, var_values []string) bool {
	if !unparsed_equation.contains(var_name) {
		println('ERROR: attempted to use an invalid variable')
		println('       attempted to use...')
		println('         var name: $var_name')
		println('         var vals: $var_values.str()')
		println('       input expression: $unparsed_equation')
		println('       make sure you are using the correct variable name!')
		exit(1)
	} else {
		return true
	}
}

fn fmt_mvars(a []string, b []string) ([]string, []string) {
	if a.len != b.len {
		println('ERROR: "a" and "b" input arrays must be parallel')
		return []string{}, []string{}
	}
	mut max_len_a := 0.0
	mut max_len_b := 0.0
	for i := 0; i < a.len; i++ {
		max_len_a = math.max(max_len_a, a[i].len)
		max_len_b = math.max(max_len_b, b[i].len)
	}
	mut fmt_a := []string{}
	mut fmt_b := []string{}
	for i := 0; i < a.len; i++ {
		mut fmt_val_a := a[i]
		mut fmt_val_b := b[i]
		size_diff_a := max_len_a - fmt_val_a.len
		size_diff_b := max_len_b - fmt_val_b.len
		for j := 0; j < size_diff_a; j++ {
			fmt_val_a += ' '
		}
		for j := 0; j < size_diff_b; j++ {
			fmt_val_b += ' '
		}
		fmt_a << fmt_val_a
		fmt_b << fmt_val_b
	}
	return fmt_a, fmt_b
}

fn mvar_fn(cmd Command, debug bool) {
	unparsed_equation := cmd.args[0]

	var_name_a, mut var_values_a := split_data(cmd.args[1])
	var_name_b, mut var_values_b := split_data(cmd.args[2])

	valid_a := validate_var(unparsed_equation, var_name_a, var_values_a)
	valid_b := validate_var(unparsed_equation, var_name_b, var_values_b)

	if !valid_a || !valid_b {
		return 
	}

	// see if we get an error
	println('check: verifying equation syntax...')
	parse_expr(unparsed_equation.replace(var_name_a, math_rt_2.str()).replace(var_name_b, math_rt_2.str()), debug, 0)
	println('check: successfully verified equation syntax')
	println('')

	// parse each of the individual values
	for i := 0; i < var_values_a.len; i++ {
		println('check: verifying values for variable "$var_name_a"...')
		parse_expr(var_values_a[i], debug, 0)
		println('check: successfully verified all values for variable "$var_name_a"')
		println('')
		println('check: verifying values for variable "$var_name_b"...')
		parse_expr(var_values_b[i], debug, 0)
		println('check: successfully verified all values for variable "$var_name_b"')
		println('')
	}

	mut combos_a := []string{}
	mut combos_b := []string{}
	mut results := []string{}

	combos_a << '"$var_name_a"'
	combos_b << '"$var_name_b"'
	results << 'OUTPUT'

	for ia := 0; ia < var_values_a.len; ia++ {
		va := var_values_a[ia]
		mut equ_with_val := unparsed_equation
		for equ_with_val.contains(var_name_a) {
			equ_with_val = equ_with_val.replace(var_name_a, va)
		}
		for ib := 0; ib < var_values_b.len; ib++ {
			vb := var_values_b[ib]
			for equ_with_val.contains(var_name_b) {
				equ_with_val = equ_with_val.replace(var_name_b, vb)
			}
			combos_a << va
			combos_b << vb
			results << parse_expr(equ_with_val, debug, 0).str()
		}
	}

	combos_a, combos_b = fmt_mvars(combos_a, combos_b)

	for i := 0; i < combos_a.len; i++ {
		println('${combos_a[i]}  |  ${combos_b[i]}  |  ${results[i]}')
	}
}

fn cmd_mvar_fn(cmd Command) {
	mvar_fn(cmd, false)
}

fn cmd_vmvar_fn(cmd Command) {
	mvar_fn(cmd, true)
}

fn cmd_rsin_fn(cmd Command) {
	input := cmd.args[0]
	result := parse_expr('sin{$input}', false, 0)
	println('RESULT: $result')
}

fn cmd_dsin_fn(cmd Command) {
	input := cmd.args[0]
	result := parse_expr('sin{to_rad{$input}}', false, 0)
	println('RESULT: $result')
}

fn cmd_rcos_fn(cmd Command) {
	input := cmd.args[0]
	result := parse_expr('cos{$input}', false, 0)
	println('RESULT: $result')
}

fn cmd_dcos_fn(cmd Command) {
	input := cmd.args[0]
	result := parse_expr('cos{to_rad{$input}}', false, 0)
	println('RESULT: $result')
}

fn cmd_rtan_fn(cmd Command) {
	input := cmd.args[0]
	result := parse_expr('tan{$input}', false, 0)
	println('RESULT: $result')
}

fn cmd_dtan_fn(cmd Command) {
	input := cmd.args[0]
	result := parse_expr('tan{to_rad{$input}}', false, 0)
	println('RESULT: $result')
}

fn debug_log(prefix string, message string, nest_lvl int) {
	mut nest_prefix := '$nest_lvl '
	for i := nest_lvl; i != 0; i-- {
		nest_prefix += '  '
	}
	println('$nest_prefix$prefix: $message')
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
	deg
	rad
}

// and they said math is for nerds...
