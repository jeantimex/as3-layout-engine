package com.jeantimex.as3.layout {
	
	// A class is used to draw dashline in AS3
	// Oyvind Nordhagen - http://www.oyvindnordhagen.com
	import com.jeantimex.as3.utils.DashedLine;
	import com.jeantimex.as3.utils.Utils;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * The grid class handles the resizing and moving logic
	 * 
	 * @author Yong Su
	 * @date 09/30/2012
	 */
	public class Grid extends MovieClip {
		/**
		 * The background highlight layer
		 */
		private var background:Sprite;
		
		/**
		 * The top frame layer displays the dashline
		 */
		private var frame:Sprite;
		
		/**
		 * Cell width
		 */
		private var cellW:Number = 0;
		
		/**
		 * Cell height
		 */
		private var cellH:Number = 0;
		
		/**
		 * The number of cells in each row
		 */
		private var sizeW:Number = 1;
		
		/**
		 * The number of cells in each column
		 */
		private var sizeH:Number = 1;
		
		/**
		 * An array that holds all blocks in the grid
		 */
		private var blocks:Array;
		
		/**
		 * Constructor
		 */
		public function Grid() {
			// Initialize the blocks array
			blocks = new Array();
			
			// Create the background and frame layers
			background = new Sprite();
			frame = new Sprite();
			addChild( background );
			addChild( frame );
		}
		
		/**
		 * Initialize the grid
		 * 
		 * @param option The object that contains the parameters to initialize the grid
		 */
		public function init( option:Object ): void {
			// Configure the grid
			x = option.hasOwnProperty( "x" ) ? option.x : 0;
			y = option.hasOwnProperty( "y" ) ? option.y : 0;
			sizeW = option.hasOwnProperty( "sizeW" ) ? option.sizeW : 1;
			sizeH = option.hasOwnProperty( "sizeH" ) ? option.sizeH : 1;
			cellW = option.hasOwnProperty( "cellW" ) ? option.cellW : 0;
			cellH = option.hasOwnProperty( "cellH" ) ? option.cellH : 0;
			
			// Clear the frame
			while ( frame.numChildren > 0 ) frame.removeChildAt( frame.numChildren - 1 );
			
			// Draw the top dashline
			var dlTop:DashedLine = new DashedLine( sizeW*cellW, 0x999999, 5, 2, 0.1 );
			dlTop.drawBetween( new Point( 0, 0 ), new Point( sizeW * cellW, 0 ) );
			
			// Draw the right dashline
			var dlRight:DashedLine = new DashedLine( sizeH*cellH, 0x999999, 5, 2, 0.1 );
			dlRight.drawBetween( new Point( sizeW * cellW, 0 ), new Point( sizeW * cellW, sizeH * cellH ) );
			
			// Draw the bottom dashline
			var dlBottom:DashedLine = new DashedLine( sizeW*cellW, 0x999999, 5, 2, 0.1 );
			dlBottom.drawBetween( new Point( 0, sizeH * cellH ), new Point( sizeW * cellW, sizeH * cellH ) );
			
			// Draw the left dashline
			var dlLeft:DashedLine = new DashedLine( sizeH*cellH, 0x999999, 5, 2, 0.1 );
			dlLeft.drawBetween( new Point( 0, 0 ), new Point( 0, sizeH * cellH ) );
			
			frame.addChild( dlTop );
			frame.addChild( dlRight );
			frame.addChild( dlBottom );
			frame.addChild( dlLeft );
			
			// Draw middle dashlines
			var i, j:int;
			var dl:DashedLine;
			
			for ( i = 1; i < sizeH; ++i ) {
				dl = new DashedLine( sizeW*cellW, 0x999999, 5, 2, 0.1 );
				dl.drawBetween( new Point( 0, i * cellH ), new Point( sizeW * cellW, i * cellH ) );
				frame.addChild( dl );
			}
			
			for ( i = 1; i < sizeW; ++i ) {
				dl = new DashedLine( sizeH*cellH, 0x999999, 5, 2, 0.1 );
				dl.drawBetween( new Point( i * cellW, 0 ), new Point( i * cellW, sizeH * cellH ) );
				frame.addChild( dl );
			}
			
			// Add frame label
			for ( i = 0; i < sizeH; ++i ) {
				for ( j = 0; j < sizeW; ++j ) {
					var lbl:TextField = new TextField();
					lbl.width = cellW;
					lbl.height = cellH;
					lbl.text = String( Number( i * sizeW + j ) );
					lbl.x = j * cellW;
					lbl.y = i * cellH;
					lbl.alpha = 0.8;
					frame.addChild( lbl );
				}
			}
		}
		
		/**
		 * Add a block to the grid
		 * 
		 * @param block A block instance
		 */
		public function addBlock( block:Block ):Boolean {
			blocks.push( block );
			addChild( block );
			return true;
		}
		
		/**
		 * Display the highlighted area
		 * 
		 * @param cells The highlighted area cell indices
		 */
		public function lightOn( cells:Array ): void {
			// Clear the current highlights
			var g:Graphics = background.graphics;
			g.clear();
			g.beginFill( 0xFF9900, 0.5 );
			
			for (var i:int = 0; i < cells.length; ++i) {
				var index:Number = cells[i];
				
				var px:Number = int( index % sizeW ) * cellW;
				var py:Number = int( index / sizeW ) * cellH;
				
				g.drawRect( px, py, cellW, cellH );
			}
			
			g.endFill();
		}
		
		/**
		 * Clear the highlighted area
		 */
		public function lightOff(): void {
			var g:Graphics = background.graphics;
			g.clear();
		}
		
		/**
		 * Get the cell indices that are covered by a block
		 * 
		 * @param block A block instance
		 * @param isDragging Whether the block is being dragged or not
		 * @return An array that contains the available cells indices
		 */
		public function getCellsIndices( block:Block, isDragging:Boolean = false ):Array {
			var i, j, k, m, n:int;
			
			// Initialize the cells that will be returned
			var cells:Array = new Array();
			
			var px:Number = block.x;
			var py:Number = block.y;
			var pw:Number = block.w;
			var ph:Number = block.h;
			
			// The starting x and y indices
			var ox:Number = Math.round( px / cellW );
			var oy:Number = Math.round( py / cellH );
			
			// The end x and y indices
			var ex:Number = ( px + pw ) / cellW;
			var ey:Number = ( py + ph ) / cellH;
			
			// If the block is being dragged, highlight the cell that it covers
			// otherwise only highlight the cell when the end x and y exceed the half size of a cell
			if ( isDragging ) {
				ex = Math.ceil( ex );
				ey = Math.ceil( ey );
			} else {
				ex = Math.round( ex );
				ey = Math.round( ey );
			}
			
			// Restrict the index
			ox = ox > sizeW ? sizeW : ox;
			oy = oy > sizeH ? sizeH : oy;
			
			ex = ex > sizeW ? sizeW : ex;
			ey = ey > sizeH ? sizeH : ey;
			
			// Put the indices to the cells
			for ( i = ox; i < ex; ++i ) {
				for ( j = oy; j < ey; ++j ) {
					cells.push( i + j * sizeW );
				}
			}
			
			// Sort the cells indices
			cells.sort( Array.NUMERIC );
			//trace("---------------");
			//trace("cells: " + cells);
			
			// Get cell min and max row index and column index
			var minRow:int = int( cells[0] / sizeW );
			var minCol:int = int( cells[0] % sizeW );
			var maxRow:int = int( cells[cells.length - 1] / sizeW );
			var maxCol:int = int( cells[cells.length - 1] % sizeW );
			/*
			trace("min row: " + minRow);
			trace("min col: " + minCol);
			trace("max row: " + maxRow);
			trace("max col: " + maxCol);
			*/
			// -------------------------------------------------------
			// 
			// During resizing, we need to find out the available cells
			//
			// -------------------------------------------------------
			if ( isDragging ) {
				// Loop through all the blocks in the grid
				// except the grid that is being dragged
				for ( i = 0; i < blocks.length; ++i ) {
					if ( blocks[i] as Block == block ) {
						continue;
					}
					
					// Get all the confilct cells (cells that are covered by the grid)
					var conflicts:Array = getConflicts( cells, blocks[i] as Block );
					
					// Remove cells from the conflict cell down to the maxRow
					for ( j = 0; j < conflicts.length; ++j ) {
						for ( k = conflicts[j]; int( k / sizeW ) <= maxRow; k += sizeW ) {
							Utils.arraySplice( cells, k );
						}
					}
				}
				
				// Get all successive areas and their cells, scan them row by row
				var areas:Array = new Array();
				
				for ( i = cells[0]; int( i / sizeW ) <= maxRow; i += sizeW ) {
					
					for ( j = 0; ; ++j ) {
						k = i + j;
						
						// If hits the "wall"(either the last cell in the row or a confilct cell), calculate the areas up to minRow
						if ( cells.indexOf( k ) < 0 || int( k % sizeW ) == maxCol ) {
							//trace( "k: " + k );
							// For each row we record the possible area and its cells
							// Later on we will find out the max area
							var obj:Object = {
								area: 0,
								cells: []
							};
							
							// Find out the cells indices
							for ( m = int( cells[0] / sizeW ); m <= int( k / sizeW ); ++m ) {
								for ( n = int( cells[0] % sizeW ); n < int( k % sizeW ) + ( ( cells.indexOf( k ) < 0 ) ? 0 : 1 ); ++n ) {
									obj.cells.push( m * sizeW + n );
								}
							}
							
							// Calculate the area
							var kCellRight:Number = ( int( k % sizeW ) + ( ( cells.indexOf( k ) < 0 ) ? 0: 1 ) ) * cellW;
							var kCellBottom:Number = ( int( k / sizeW ) + 1 ) * cellH;
							
							var areaRight:Number = ( block.x + block.w ) < kCellRight ? mouseX : kCellRight;
							var areaBottom:Number = ( block.y + block.h ) < kCellBottom ? mouseY : kCellBottom;
							
							var areaWidth:Number = areaRight - int( cells[0] % sizeW ) * cellW;
							var areaHeight:Number = areaBottom - int( cells[0] / sizeW ) * cellH;
							
							//trace("[" + k + "]: " + kCellRight + ", " + kCellBottom);
							//trace("[m]: " + areaWidth + ", " + areaHeight);
							
							obj.area = areaWidth * areaHeight;
							
							//trace( "row " + int( i / sizeW ) + " [area: " + obj.area + ", cells: " + obj.cells + "]" );
							
							areas.push( obj );
							
							break;
						}
					}
				}
				
				// Compare the areas and find out the maximum one and return its cells indices
				areas.sortOn( [ "area" ], [ Array.NUMERIC | Array.DESCENDING ] );
				
				if ( areas.length > 0 ) {
					return areas[0].cells;
				}
			}
			
			return cells;
		}
		
		/**
		 * Get the cells indices that are covered by a block
		 * 
		 * @param cells A specific area with the cells indices
		 * @param block A block that covers the cells
		 * @return An array that contains the blocks in the area
		 */
		private function getConflicts( cells:Array, block:Block ):Array {
			var conflicts:Array = new Array();
			for ( var i:int = 0; i < cells.length; ++i ) {
				if ( block.cells.indexOf( cells[i] ) > -1 ) {
					conflicts.push( cells[i] );
				}
			}
			return conflicts;
		}
		
		/**
		 * Get area position and size info based on a series of cells
		 * 
		 * @param cells An array contains cells indices
		 * @return An object that contains the area position and size
		 */
		public function getCellsInfo( cells:Array ):Object {
			cells.sort( Array.NUMERIC );
			
			// Left vertex index
			var firstIdx:Number = cells[0];
			
			var px:Number = int( firstIdx % sizeW ) * cellW;
			var py:Number = int( firstIdx / sizeW ) * cellH;
			
			// Lower right vertex index
			var lastIdx:Number = cells[cells.length - 1];
			var w:Number = ( int( lastIdx % sizeW ) - int( firstIdx % sizeW ) + 1 ) * cellW;
			var h:Number = ( int( lastIdx / sizeW ) - int( firstIdx / sizeW ) + 1 ) * cellH;
			
			return { x:px, y:py, w:w, h:h };
		}
	}
}