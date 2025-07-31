import { ref, computed, onMounted, onUnmounted } from "vue"

export function useResponsive() {
  const windowWidth = ref(window.innerWidth)

  // Check if mobile (≤768px)
  const isMobile = computed(() => {
    return windowWidth.value <= 768
  })

  // Check if desktop (>768px)
  const isDesktop = computed(() => {
    return windowWidth.value > 768
  })

  // Responsive grid columns
  const gridCols = computed(() => {
    return isMobile.value ? 1 : 2
  })

  // Handle window resize
  function handleResize() {
    windowWidth.value = window.innerWidth
  }

  onMounted(() => {
    window.addEventListener("resize", handleResize)
  })

  onUnmounted(() => {
    window.removeEventListener("resize", handleResize)
  })

  return {
    windowWidth,
    isMobile,
    isDesktop,
    gridCols
  }
}
