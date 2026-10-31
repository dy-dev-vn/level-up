import { Head, Link, useForm } from '@inertiajs/react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'

export default function Register() {
  const form = useForm({ user: { email_address: '', password: '', password_confirmation: '' } })
  return <><Head title="Tạo tài khoản"/><main className="grid min-h-screen place-items-center bg-muted/30 p-5"><form onSubmit={(event) => { event.preventDefault(); form.post('/registrations') }} className="w-full max-w-sm space-y-5 rounded-xl border bg-background p-7 shadow-sm"><div><p className="text-sm font-medium text-muted-foreground">LEVEL UP</p><h1 className="mt-2 text-2xl font-semibold">Tạo tài khoản</h1><p className="mt-1 text-sm text-muted-foreground">Bắt đầu kiểm chứng năng lực nghề nghiệp.</p></div>{(['email_address', 'password', 'password_confirmation'] as const).map((field) => <div key={field} className="space-y-2"><Label htmlFor={field}>{field === 'email_address' ? 'Email' : field === 'password' ? 'Mật khẩu' : 'Nhập lại mật khẩu'}</Label><Input id={field} type={field === 'email_address' ? 'email' : 'password'} autoComplete={field === 'email_address' ? 'email' : 'new-password'} value={form.data.user[field]} onChange={(e) => form.setData('user', { ...form.data.user, [field]: e.target.value })}/>{(form.errors as Record<string,string>)[`user.${field}`] && <p className="text-sm text-destructive">{(form.errors as Record<string,string>)[`user.${field}`]}</p>}</div>)}<Button className="w-full" disabled={form.processing}>Tạo tài khoản</Button><p className="text-center text-sm text-muted-foreground">Đã có tài khoản? <Link className="underline" href="/session/new">Đăng nhập</Link></p></form></main></>
}
