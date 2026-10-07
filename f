#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <openssl/evp.h>

#define NUM_EXPERIMENTS 5

static unsigned int hash24(const unsigned char *msg, size_t len)
{
    unsigned char md[EVP_MAX_MD_SIZE];
    unsigned int md_len;
    EVP_MD_CTX *ctx = EVP_MD_CTX_new();
    EVP_DigestInit_ex(ctx, EVP_sha256(), NULL);
    EVP_DigestUpdate(ctx, msg, len);
    EVP_DigestFinal_ex(ctx, md, &md_len);
    EVP_MD_CTX_free(ctx);
    return ((unsigned int)md[0] << 16) | ((unsigned int)md[1] << 8) | md[2];
}

static long attack_oneway(unsigned long long seed)
{
    unsigned long long target_msg = seed * 7919ULL + 12345ULL;
    unsigned int target = hash24((unsigned char *)&target_msg, 8);
    unsigned long long m = seed * 1000000007ULL + 99991ULL;
    long count = 0;
    while (1) {
        m++;
        count++;
        if (m != target_msg && hash24((unsigned char *)&m, 8) == target)
            return count;
    }
}

static long attack_collision(unsigned long long seed)
{
    unsigned int *table = calloc(1u << 24, sizeof(unsigned int));
    unsigned long long base = seed * 1000003ULL + 17ULL;
    long count = 0;
    while (1) {
        unsigned long long m = base + count;
        count++;
        unsigned int h = hash24((unsigned char *)&m, 8);
        if (table[h] != 0) {
            free(table);
            return count;
        }
        table[h] = (unsigned int)count;
    }
}

int main(void)
{
    double s1 = 0, s2 = 0;
    srand(time(NULL));
    for (int i = 0; i < NUM_EXPERIMENTS; i++) {
        unsigned long long seed = ((unsigned long long)rand() << 20) ^ rand();
        long a = attack_oneway(seed);
        long b = attack_collision(seed);
        printf("Lan %d: one-way = %ld, collision = %ld\n", i + 1, a, b);
        fflush(stdout);
        s1 += a; s2 += b;
    }
    printf("\nTrung binh one-way   : %.0f\n", s1 / NUM_EXPERIMENTS);
    printf("Trung binh collision : %.0f\n", s2 / NUM_EXPERIMENTS);
    return 0;
}
