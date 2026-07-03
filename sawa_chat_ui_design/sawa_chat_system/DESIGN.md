---
name: Sawa Chat System
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#434655'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#737686'
  outline-variant: '#c3c6d7'
  surface-tint: '#0053db'
  primary: '#004ac6'
  on-primary: '#ffffff'
  primary-container: '#2563eb'
  on-primary-container: '#eeefff'
  inverse-primary: '#b4c5ff'
  secondary: '#00687a'
  on-secondary: '#ffffff'
  secondary-container: '#57dffe'
  on-secondary-container: '#006172'
  tertiary: '#006229'
  on-tertiary: '#ffffff'
  tertiary-container: '#007e37'
  on-tertiary-container: '#c1ffc5'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dbe1ff'
  primary-fixed-dim: '#b4c5ff'
  on-primary-fixed: '#00174b'
  on-primary-fixed-variant: '#003ea8'
  secondary-fixed: '#acedff'
  secondary-fixed-dim: '#4cd7f6'
  on-secondary-fixed: '#001f26'
  on-secondary-fixed-variant: '#004e5c'
  tertiary-fixed: '#6bff8f'
  tertiary-fixed-dim: '#4ae176'
  on-tertiary-fixed: '#002109'
  on-tertiary-fixed-variant: '#005321'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  title-lg:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 17px
    fontWeight: '400'
    lineHeight: 26px
  body-md:
    fontFamily: Inter
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
  label-md:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '500'
    lineHeight: 18px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  container-padding-mobile: 20px
  container-padding-tablet: 32px
  gutter: 16px
  stack-gap-sm: 8px
  stack-gap-md: 16px
  stack-gap-lg: 24px
  section-margin: 40px
---

## Brand & Style

The design system is engineered to evoke a sense of "Fluid Sophistication." It targets a globally-connected audience that values both the high-utility performance of a productivity tool and the expressive aesthetic of a lifestyle social app. The UI is characterized by a premium, airy feel that balances professional reliability with creative energy.

The style is a hybrid of **Minimalism** and **Glassmorphism**, leveraging the structured clarity of Apple's interface guidelines with the vibrant, expressive depth found in modern social platforms. Key stylistic pillars include:
- **Depth through Translucency:** Using backdrop blurs to maintain context and create a sense of physical space.
- **Organic Geometry:** High-radius corners that feel approachable and soft.
- **Dynamic Atmosphere:** Subtle mesh gradients provide a "living" background that reacts to content.
- **Intentional Negative Space:** Large margins and generous padding to reduce cognitive load and highlight media content.

## Colors

The palette is anchored by a vibrant **Electric Blue** (Primary) to signify trust and high-speed communication. A **Cyan** (Secondary) is used for supporting interactive elements and subtle accents, while **Emerald** (Tertiary) serves as the success and "active" status indicator.

The system utilizes a dual-surface approach:
- **Light Mode:** Uses a "Soft Slate" base (#F8FAFC) to minimize eye strain. Surfaces are predominantly pure white with high-transparency glass overlays.
- **Dark Mode:** Employs a "Deep Midnight" base (#0F172A). Rather than pure black, this navy-tinted dark mode preserves depth perception and allows gradients to glow naturally.
- **Gradients:** Primary actions should use a linear gradient from Primary to Secondary at a 135-degree angle.

## Typography

The design system utilizes **Inter** for its exceptional legibility and modern, systematic feel. The type scale is optimized for high-density chat environments while maintaining a premium editorial look in profile and discovery views.

- **Tracking:** Headings use negative letter spacing to create a compact, "designed" look typical of premium mobile apps. Labels use slightly increased tracking for better readability at small sizes.
- **Hierarchy:** Use FontWeight 600 (SemiBold) for interactive elements and 400 (Regular) for message bubbles and long-form content.
- **Color Contrast:** Primary text uses Slate 900 (Light) / Slate 50 (Dark). Secondary text uses Slate 500 (Light) / Slate 400 (Dark).

## Layout & Spacing

This design system follows a **Dynamic Fluid Grid** model. It prioritizes generous whitespace to ensure the "Premium" brand promise.

- **Mobile Rhythm:** 20px side margins are the default. Internal card padding is set to 16px.
- **Vertical Rhythm:** Elements are spaced in multiples of 4px. Use 24px spacing between distinct sections and 8px between related items within a group.
- **Safe Areas:** Navigation bars and input fields must respect the bottom home-indicator safe area, using a minimum of 34px padding-bottom on modern bezel-less devices.
- **Reflow:** On larger screens (tablets), the chat interface moves from a full-screen view to a split-pane view (320px sidebar / flexible main area).

## Elevation & Depth

Elevation is communicated through a combination of **Ambient Shadows** and **Glassmorphism**, rather than traditional high-contrast shadows.

- **Level 1 (Base):** Background surfaces (#F8FAFC / #0F172A).
- **Level 2 (Cards/Bubbles):** White or Deep Slate surfaces with a 1px subtle border (Opacity 5%) and a soft, spread-out shadow: `y: 4, blur: 20, color: rgba(0,0,0, 0.04)`.
- **Level 3 (Modals/Floating Actions):** Use a "Glass" effect. Backdrop-filter: `blur(20px)`. Surface color: `rgba(255, 255, 255, 0.7)` in light mode or `rgba(30, 41, 59, 0.7)` in dark mode.
- **Interactions:** When an element is pressed, it should subtly scale down to 0.98 and increase shadow spread to simulate being "pressed" into the surface.

## Shapes

The shape language is defined by large, friendly radii that align with the "Premium/Modern" aesthetic.

- **Standard Containers:** Cards, menus, and large buttons use a `20px` radius.
- **Message Bubbles:** Incoming bubbles use `20px` on three corners and `4px` on the bottom-left. Outgoing bubbles use `20px` on three corners and `4px` on the bottom-right.
- **Small Elements:** Tooltips and chips use `12px` radius.
- **Media:** Images and videos within the feed use a `24px` radius to create a framed, "gallery" look.

## Components

### Buttons
- **Primary:** Gradient fill (Primary to Secondary), 20px radius, white text, soft shadow.
- **Secondary:** Transparent with 1.5px border of Primary color, or light-blue tint background.
- **Icon Buttons:** Circular or 16px rounded squares with a glass background.

### Input Fields
- **Search/Chat Bar:** 24px radius, subtle background color (Slate 100 / Slate 800), and a 1px inset border. Inside padding: 16px horizontal.

### Chat Bubbles
- **Recipient:** Background Slate 100 (Light) / Slate 800 (Dark). Text Slate 900 / Slate 50.
- **Sender:** Background Gradient (Primary to Secondary). Text White.
- **Spacing:** 4px between bubbles from the same sender, 12px between different senders.

### Navigation Bar
- **Glassmorphic:** 80% opacity with 20px backdrop blur.
- **Icons:** Thin-stroke (1.5pt) linear icons that switch to solid-fill when active.

### Cards (Stories/Profiles)
- Use an 18:9 aspect ratio for stories.
- Apply a 28px corner radius.
- Bottom-aligned labels with a dark-to-transparent linear gradient overlay to ensure text legibility over media.

### Chips
- Height: 32px. Radius: 16px.
- Use Secondary color at 10% opacity for the background and 100% opacity for the label text.