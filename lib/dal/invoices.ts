import { getSupabaseClient } from '../supabase'

export type InvoiceRecord = {
  id: number
  invoice_number: string
  invoice_date: string
  transaction_type: string
  input_mode: string
  eway_bill: string | null
  buyer_id: number | null
  buyer_name: string
  buyer_address: string
  buyer_gstin: string | null
  buyer_state_code: number | null
  tax_type: string
  total_invoice_value: string
  created_at: string
  updated_at: string
  flagged: boolean
  deletedAt: string | null
  roundoff: string | null
}

export type LineItemRecord = {
  id: number
  invoice_id: number
  hsn_sac_code: string
  description: string
  quantity: string
  unit: string
  rate: string
  taxable_value: string
  created_at: string
  roundoff: string
  deletedAt: string | null
}

export async function listInvoices(): Promise<InvoiceRecord[]> {
  const supabase = getSupabaseClient()
  const { data, error } = await supabase
    .from('Invoice')
    .select('*')
    .is('deletedAt', null)
    .order('created_at', { ascending: false })
  if (error) throw error
  return data ?? []
}

export async function getInvoiceWithItems(id: number): Promise<{
  invoice: InvoiceRecord | null
  items: LineItemRecord[]
}> {
  const supabase = getSupabaseClient()
  const [{ data: invoice, error: e1 }, { data: items, error: e2 }] = await Promise.all([
    supabase.from('Invoice').select('*').eq('id', id).maybeSingle(),
    supabase.from('LineItem').select('*').eq('invoice_id', id).is('deletedAt', null).order('id'),
  ])
  if (e1) throw e1
  if (e2) throw e2
  return { invoice, items: items ?? [] }
}


