package game

import rl "vendor:raylib"
import "core:fmt"

main :: proc() {
	screen_height : i32 = 720
	screen_width : i32 = 1280
	rl.InitWindow(screen_width, screen_height, "Tetris with John")
	playfield_width : int : 10
	playfield_height : int : 20

	playfield_state : [playfield_height][playfield_width]bool = {}

	for !rl.WindowShouldClose() {
		rl.ClearBackground(rl.BLACK)
		rl.BeginDrawing()

		cell_size : f32 = 24

		playfield_position := [2]f32{10, 10}
		playfield_right_side_x : f32 = playfield_position.x + cell_size * f32(playfield_width)
		playfield_bottom_y : f32 = playfield_position.y + cell_size * f32(playfield_height)

		for row in 0..=playfield_height {
				rl.DrawLineV(
					[2]f32{
						playfield_position.x,
						playfield_position.y + cell_size * f32(row)
					},
					[2]f32{
						playfield_right_side_x,
						playfield_position.y + cell_size * f32(row)},
					rl.WHITE
				)
		}

		for col in 0..=playfield_width {
			rl.DrawLineV(
				[2]f32{
					playfield_position.x + cell_size * f32(col),
					playfield_position.y
				},
				[2]f32{
					playfield_position.x + cell_size * f32(col),
					playfield_bottom_y
				},
				rl.WHITE
			)
		}

		// debug - set block state
		mouse_pos := rl.GetMousePosition()
		mouse_pos_rel_playfield := mouse_pos - playfield_position
		mouse_playfield_pos := [2]int {
			int(mouse_pos_rel_playfield.x) / int(cell_size),
			int(mouse_pos_rel_playfield.y) / int(cell_size),
		} // 2d index into 2d aray
		for row in 0..<playfield_height {
			for col in 0..<playfield_width {
				if rl.IsMouseButtonDown(.LEFT) {
					if row == mouse_playfield_pos.y && col == mouse_playfield_pos.x {
						playfield_state[row][col] = true
					}
				}
				if rl.IsMouseButtonDown(.RIGHT) {
					if row == mouse_playfield_pos.y && col == mouse_playfield_pos.x {
						playfield_state[row][col] = false
					}
				}
			}
			mouse_playfield_pos_x_text := fmt.ctprintf("x = %d", mouse_playfield_pos.x)
			mouse_playfield_pos_y_text := fmt.ctprintf("y = %d", mouse_playfield_pos.y)
			rl.DrawText(mouse_playfield_pos_x_text, 1000, 10, 72, rl.WHITE)
			rl.DrawText(mouse_playfield_pos_y_text, 1000, 84, 72, rl.WHITE)
		}
		for row in 0..<playfield_height {
			for col in 0..<playfield_width {
				if playfield_state[row][col] == true {
					block := rl.Rectangle { playfield_position.x + f32(col) * cell_size, playfield_position.y + f32(row) * cell_size, cell_size, cell_size}
					rl.DrawRectangleRec(block, rl.SKYBLUE)
				}
			}
		}
		rl.EndDrawing()
		free_all(context.temp_allocator)
	}
}