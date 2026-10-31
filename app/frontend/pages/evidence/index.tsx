import { Head, Link } from '@inertiajs/react'
import { Plus } from 'lucide-react'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Layout } from '@/components/layout'

type Evidence = { id: number; title: string; format: string; summary: string; resource_url: string; status: string; skills: string[] }
export default function EvidenceIndex({ evidence }: { evidence: Evidence[] }) {
 return <Layout><Head title="Bằng chứng"/><main className="mx-auto max-w-5xl space-y-6 px-5 py-10"><header className="flex items-center justify-between"><div><h1 className="text-3xl font-semibold">Bằng chứng năng lực</h1><p className="mt-2 text-muted-foreground">Mỗi artifact kết nối với kỹ năng và trải nghiệm thực tế của bạn.</p></div><Button asChild><Link href="/evidence/new"><Plus className="mr-2 size-4"/>Thêm bằng chứng</Link></Button></header><div className="grid gap-4">{evidence.length ? evidence.map((item) => <Card key={item.id}><CardHeader className="flex flex-row items-start justify-between"><div><CardTitle className="text-lg">{item.title}</CardTitle><p className="mt-1 text-sm text-muted-foreground">{item.format}</p></div><Badge variant={item.status === 'verified' ? 'default' : 'secondary'}>{item.status}</Badge></CardHeader><CardContent><p className="text-sm">{item.summary}</p><div className="mt-4 flex flex-wrap gap-2">{item.skills.map((skill) => <Badge key={skill} variant="outline">{skill}</Badge>)}</div>{item.resource_url && <a className="mt-4 inline-block text-sm underline" href={item.resource_url} target="_blank" rel="noreferrer">Mở artifact</a>}</CardContent></Card>) : <Card><CardContent className="py-12 text-center text-muted-foreground">Chưa có bằng chứng. Hãy thêm một ứng dụng, tài liệu thiết kế hoặc bài viết kỹ thuật.</CardContent></Card>}</div></main></Layout>
}
