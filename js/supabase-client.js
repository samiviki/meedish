// Centralized Supabase client initializer
// Depends on js/config-loader.js which exposes window.fetchConfig
async function initSupabaseClient() {
    try {
        if (window.supabase?.from && window.supabase?.auth) return window.supabase;

        const supabaseLibrary = window.supabaseJs || window.supabase;
        if (!supabaseLibrary?.createClient) {
            throw new Error('Supabase library failed to load');
        }

        window.supabaseJs = supabaseLibrary;
        const config = await fetchConfig();
        window.supabase = supabaseLibrary.createClient(config.SUPABASE_URL, config.SUPABASE_ANON_KEY, {
            auth: {
                persistSession: true,
                autoRefreshToken: true,
            }
        });
        return window.supabase;
    } catch (err) {
        console.error('initSupabaseClient error:', err);
        throw err;
    }
}

window.initSupabaseClient = initSupabaseClient;

// Convenience getter
function getSupabase() {
    return window.supabase;
}

window.getSupabase = getSupabase;
