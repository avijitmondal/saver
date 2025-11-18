// Mobile Menu Toggle
const mobileMenuToggle = document.getElementById('mobileMenuToggle');
const navMenu = document.querySelector('.nav-menu');

if (mobileMenuToggle) {
    mobileMenuToggle.addEventListener('click', () => {
        navMenu.classList.toggle('active');
        mobileMenuToggle.classList.toggle('active');
    });

    // Close menu when clicking on a link
    document.querySelectorAll('.nav-menu a').forEach(link => {
        link.addEventListener('click', () => {
            navMenu.classList.remove('active');
            mobileMenuToggle.classList.remove('active');
        });
    });
}

// Screenshots Carousel
const screenshotsTrack = document.getElementById('screenshotsTrack');
const prevBtn = document.getElementById('prevBtn');
const nextBtn = document.getElementById('nextBtn');

if (screenshotsTrack && prevBtn && nextBtn) {
    let currentPosition = 0;
    const scrollAmount = 320; // 300px width + 20px gap

    nextBtn.addEventListener('click', () => {
        const maxScroll = screenshotsTrack.scrollWidth - screenshotsTrack.parentElement.offsetWidth;
        currentPosition = Math.min(currentPosition + scrollAmount, maxScroll);
        screenshotsTrack.style.transform = `translateX(-${currentPosition}px)`;
        updateButtonStates();
    });

    prevBtn.addEventListener('click', () => {
        currentPosition = Math.max(currentPosition - scrollAmount, 0);
        screenshotsTrack.style.transform = `translateX(-${currentPosition}px)`;
        updateButtonStates();
    });

    function updateButtonStates() {
        const maxScroll = screenshotsTrack.scrollWidth - screenshotsTrack.parentElement.offsetWidth;
        prevBtn.style.opacity = currentPosition === 0 ? '0.5' : '1';
        prevBtn.style.cursor = currentPosition === 0 ? 'default' : 'pointer';
        nextBtn.style.opacity = currentPosition >= maxScroll ? '0.5' : '1';
        nextBtn.style.cursor = currentPosition >= maxScroll ? 'default' : 'pointer';
    }

    // Auto-scroll carousel
    let autoScrollInterval;
    let isPaused = false;

    function startAutoScroll() {
        autoScrollInterval = setInterval(() => {
            if (!isPaused) {
                const maxScroll = screenshotsTrack.scrollWidth - screenshotsTrack.parentElement.offsetWidth;
                if (currentPosition >= maxScroll) {
                    currentPosition = 0;
                } else {
                    currentPosition = Math.min(currentPosition + scrollAmount, maxScroll);
                }
                screenshotsTrack.style.transform = `translateX(-${currentPosition}px)`;
                updateButtonStates();
            }
        }, 3000);
    }

    function stopAutoScroll() {
        clearInterval(autoScrollInterval);
    }

    // Pause auto-scroll on hover
    screenshotsTrack.parentElement.addEventListener('mouseenter', () => {
        isPaused = true;
    });

    screenshotsTrack.parentElement.addEventListener('mouseleave', () => {
        isPaused = false;
    });

    // Start auto-scroll
    startAutoScroll();

    // Initialize button states
    updateButtonStates();
}

// Smooth scroll for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            const headerOffset = 80;
            const elementPosition = target.getBoundingClientRect().top;
            const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

            window.scrollTo({
                top: offsetPosition,
                behavior: 'smooth'
            });
        }
    });
});

// Intersection Observer for fade-in animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Apply fade-in to feature cards and other elements
document.querySelectorAll('.feature-card, .screenshot-item, .stat-card').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(20px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    observer.observe(el);
});

// Header shadow on scroll
const header = document.querySelector('.header');
let lastScroll = 0;

window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;
    
    if (currentScroll > 50) {
        header.style.boxShadow = '0 2px 12px rgba(0, 0, 0, 0.15)';
    } else {
        header.style.boxShadow = '0 2px 8px rgba(0, 0, 0, 0.1)';
    }
    
    lastScroll = currentScroll;
});

// Add loading animation
window.addEventListener('load', () => {
    document.body.style.opacity = '0';
    document.body.style.transition = 'opacity 0.5s ease';
    setTimeout(() => {
        document.body.style.opacity = '1';
    }, 100);
});
