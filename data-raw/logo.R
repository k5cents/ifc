## Generate the ifc hex sticker
## Run manually: source("data-raw/logo.R")
## Output: man/figures/logo.png

library(hexSticker)
library(ggplot2)
library(sysfonts)
library(showtext)

font_add_google("Overpass", "overpass")
showtext_auto()

# ── Palette ────────────────────────────────────────────────────────────────────
bg_col    <- "#1B2E4A"   # deep navy
bord_col  <- "#0E1D2F"   # darker navy border
tile_fill <- "#FFFFFF18" # subtle white fill for cells
tile_bord <- "#FFFFFF45" # white cell borders
num_col   <- "#FFFFFF"   # white day numbers
hdr_col   <- "#FFFFFF60" # white 38% opacity — day-of-week headers

# ── Grid data ──────────────────────────────────────────────────────────────────
# 4 rows × 7 cols; y=3 is top (week 1), y=0 is bottom (week 4)
# x=0 = Sunday, x=6 = Saturday
grid <- data.frame(
  x   = rep(0:6, 4),
  y   = rep(3:0, each = 7),
  day = 1:28
)

# Day-of-week header row
headers <- data.frame(
  x     = 0:6,
  y     = 4,
  label = c("S", "M", "T", "W", "T", "F", "S")
)

# ── Subplot ────────────────────────────────────────────────────────────────────
p <- ggplot() +
  # Calendar cells
  geom_tile(
    data      = grid,
    mapping   = aes(x = x, y = y),
    width     = 0.88,
    height    = 0.88,
    fill      = tile_fill,
    color     = tile_bord,
    linewidth = 0.3
  ) +
  # Day numbers inside cells
  geom_text(
    data     = grid,
    mapping  = aes(x = x, y = y, label = day),
    color    = num_col,
    size     = 8,
    family   = "overpass",
    fontface = "bold"
  ) +
  # Day-of-week headers
  geom_text(
    data     = headers,
    mapping  = aes(x = x, y = y, label = label),
    color    = hdr_col,
    size     = 13,
    family   = "overpass",
    fontface = "bold"
  ) +
  coord_fixed(
    xlim = c(-0.6, 6.6),
    ylim = c(-0.6, 4.6)
  ) +
  theme_void() +
  theme(
    panel.background = element_blank(),
    plot.background  = element_blank()
  )

# ── Sticker ────────────────────────────────────────────────────────────────────
sticker(
  subplot    = p,
  package    = "ifc",
  p_size     = 23,
  p_color    = "white",
  p_family   = "overpass",
  p_fontface = "bold",
  p_x        = 1,
  p_y        = 1.57,
  s_x        = 1,
  s_y        = 0.92,
  s_width    = 1.35,
  s_height   = 1.1,
  h_fill     = bg_col,
  h_color    = bord_col,
  h_size     = 1.4,
  filename   = "man/figures/logo.png",
  dpi        = 320
)

message("Logo saved to man/figures/logo.png")
