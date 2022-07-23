import { ANSWER } from '@test-example/lib'
import numeral from 'numeral'

export function getAnswer() {
  return numeral(ANSWER).format('0,0')
}
