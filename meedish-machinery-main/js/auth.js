// Lightweight auth helpers that rely on window.supabase being initialized
async function ensureClient() {
    if (!window.supabase?.from || !window.supabase?.auth) await initSupabaseClient();
    return window.supabase;
}

async function signUp(email, password) {
    const supabase = await ensureClient();
    return supabase
        .from('users')
        .insert([{ email, password, role: 'customer', status: 'active' }])
        .select()
        .single();
}

async function signIn(email, password) {
    const supabase = await ensureClient();
    const { data, error } = await supabase
        .from('users')
        .select('*')
        .eq('email', email)
        .single();

    if (error || !data || data.password !== password) {
        return { data: null, error: new Error('Invalid email or password') };
    }

    localStorage.setItem('current_user', JSON.stringify(data));
    return { data: { user: data }, error: null };
}

async function signOut() {
    localStorage.removeItem('current_user');
    localStorage.removeItem('current_admin_user');
    localStorage.removeItem('current_super_admin');
    return { error: null };
}

async function getSession() {
    const userStr = localStorage.getItem('current_user') || localStorage.getItem('current_admin_user');
    if (!userStr) return null;

    try {
        return { user: JSON.parse(userStr) };
    } catch (error) {
        console.error('Failed to parse stored user session:', error);
        return null;
    }
}

function onAuthStateChange(callback) {
    callback('INITIAL_SESSION', null);
    return { data: { subscription: { unsubscribe() { } } } };
}

window.auth = {
    signUp,
    signIn,
    signOut,
    getSession,
    onAuthStateChange,
};
