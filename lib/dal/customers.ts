import { getSupabaseClient } from '../supabase'
import type { PostgrestError } from '@supabase/supabase-js'

export type CustomerRecord = {
  id: number
  name: string
  address: string
  city: string
  pincode: string | null
  gstin: string | null
  phone: string
  email: string | null
  state_id: number | null
  pan_number: string | null
  created_at: string
  updated_at: string
  deletedAt: string | null
}

export async function listCustomers(): Promise<CustomerRecord[]> {
  const supabase = getSupabaseClient()
  const { data, error } = await supabase
    .from('Customer')
    .select('*')
    .is('deletedAt', null)
    .order('created_at', { ascending: false })
  if (error) throw error
  return data ?? []
}

export async function getCustomerById(id: number): Promise<CustomerRecord | null> {
  const supabase = getSupabaseClient()
  const { data, error } = await supabase
    .from('Customer')
    .select('*')
    .eq('id', id)
    .maybeSingle()
  if (error) throw error
  return data
}

export type UpsertCustomerInput = Omit<CustomerRecord, 'id' | 'created_at' | 'updated_at' | 'deletedAt'> & {
  id?: number
}

export async function upsertCustomer(input: UpsertCustomerInput): Promise<CustomerRecord> {
  const supabase = getSupabaseClient()
  const { data, error } = await supabase
    .from('Customer')
    .upsert(input, { onConflict: 'id' })
    .select('*')
    .single()
  if (error) throw error
  return data
}

export async function softDeleteCustomer(id: number): Promise<{ success: true } | PostgrestError> {
  const supabase = getSupabaseClient()
  const { error } = await supabase
    .from('Customer')
    .update({ deletedAt: new Date().toISOString() })
    .eq('id', id)
  if (error) return error
  return { success: true }
}


